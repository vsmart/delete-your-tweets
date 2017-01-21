defmodule DeleteYourTweets.TweetController do
  use DeleteYourTweets.Web, :controller
  use Timex

  def delete(conn, %{"older_than_months" => older_than_months}) do
    until_date = get_until_date(older_than_months)
    latest_tweet_id = get_latest_tweet_id(until_date)
    %ExTwitter.Model.Tweet{created_at: created_at, id: id, text: text} =  fetch_and_search_for_max_id(until_date, latest_tweet_id)

    info = "First tweet older than #{older_than_months} is: \nDate: #{created_at} ID: #{id} | Text: #{text}"

    conn
    |> put_flash(:info, info)
    |> put_view(DeleteYourTweets.PageView)
    |> render("index.html", step: :three)
  end

  def get_until_date(months_str) do
    months = String.to_integer(months_str)

    Timex.today
    |> Timex.shift(months: -months)
  end

  defp get_latest_tweet_id(until_date)  do
    [%ExTwitter.Model.Tweet{id: id, text: text}] = ExTwitter.user_timeline(count: 1, until: until_date)
    id
  end

  defp fetch_and_search_for_max_id(date, max_id) do
    tweets = fetch_tweets(max_id)
    number_of_tweets = Enum.count(tweets)

    older_tweet = Enum.find(tweets, fn tweet -> older_than_date(date, tweet)  end)

    if (older_tweet == nil) && (number_of_tweets > 0) do
      last_id = last_tweet_id(tweets)
      fetch_and_search_for_max_id(date, last_id)
    else
      older_tweet
    end
  end

  defp older_than_date(date,tweet) do
    %ExTwitter.Model.Tweet{created_at: created_at} = tweet
    parsed_date = Timex.parse!(created_at, "%a %b %d %T %z %Y", :strftime)
    Timex.before?(parsed_date, date)
  end

  defp fetch_and_delete_from(max_id) do
    tweets = fetch_tweets(max_id)
    number_of_tweets = Enum.count(tweets)

    tweets |> delete_tweets

    if number_of_tweets > 0 do
      last_id = last_tweet_id(tweets)
      fetch_and_delete_from(last_id)
    end
  end

  defp fetch_tweets(max_id) do
    ExTwitter.user_timeline(count: 10, max_id: max_id)
  end

  defp delete_tweets(tweets) do
    Enum.map(tweets,
      fn tweet ->
        ExTwitter.destroy_status(tweet.id)
      end)
  end

  defp last_tweet_id(tweets) do
    %ExTwitter.Model.Tweet{created_at: date, id: last_tweet_id} = List.last(tweets)
    last_tweet_id
  end
end
