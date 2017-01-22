defmodule DeleteYourTweets.TweetController do
  use DeleteYourTweets.Web, :controller
  use Timex

  def delete(conn, %{"delete_from" => delete_from}) do
    from_date = Timex.now
    to_date = calculate_to_date(delete_from)

    info =  "From date: #{IO.inspect from_date} and to date: #{IO.inspect to_date}"
    to_tweet_id = get_newest_tweet()

    # %ExTwitter.Model.Tweet{created_at: created_at, id: id, text: text} =  fetch_and_search_for_max_id(to_date, latest_tweet_id)

    conn
    |> put_flash(:info, info)
    |> put_view(DeleteYourTweets.PageView)
    |> render("index.html", step: :three)
  end

  def calculate_to_date(delete_from) do
    case delete_from do
      "today" -> Timex.today
      "this_week" -> Timex.today |> Timex.shift(weeks: -1)
      "this_month" -> Timex.today |> Timex.shift(months: -1)
    end
  end

  defp get_newest_tweet()  do
    [%ExTwitter.Model.Tweet{id: id}] = ExTwitter.user_timeline(count: 1)
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
