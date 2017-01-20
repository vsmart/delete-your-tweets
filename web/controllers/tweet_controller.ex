defmodule DeleteYourTweets.TweetController do
  use DeleteYourTweets.Web, :controller
  use Timex

  def delete(conn, %{"older_than_months" => older_than_months}) do
    until_date = get_until_date(older_than_months)
    latest_tweet_id = get_latest_tweet_id(until_date)
    latest_tweet_id =  fetch_and_search_for_max_id(until_date, latest_tweet_id)
    # fetch_and_delete_from(latest_tweet_id)

    conn
    |> put_flash(:info, "Deleted a bunch of your tweets. Wheee 🎉")
    |> put_view(DeleteYourTweets.PageView)
    |> render("index.html", step: :three)
  end

  def get_until_date(months_str) do
    months = String.to_integer(months_str)

    Timex.today
    |> Timex.shift(months: -months)
    |> Timex.format!("%Y-%m-%d", :strftime)
  end

  defp get_latest_tweet_id(until_date)  do
    [%ExTwitter.Model.Tweet{id: id, text: text}] = ExTwitter.user_timeline(count: 1, until: until_date)
    IO.puts text
    id
  end

  defp fetch_and_search_for_max_id(date, max_id) do
    tweets = fetch_tweets(max_id)
    number_of_tweets = Enum.count(tweets)
    IO.puts "fetch_and_searching #{number_of_tweets} tweets."
    id = -1

    Enum.each(tweets, fn tweet ->
      if older_than_date(date, tweet) do
        IO.puts "FOUND IT"
        id = tweet.id
      end
    end)


    if (id != -1) || (number_of_tweets > 0) do
      last_id = last_tweet_id(tweets)
      fetch_and_search_for_max_id(date, last_id)
    end
  end

  defp older_than_date(date,tweet) do
    %ExTwitter.Model.Tweet{created_at: created_at} = tweet
    parsed_date = Timex.parse!(created_at, "%a %b %d %T %z %Y", :strftime)
    (parsed_date > date)
  end

  defp fetch_and_delete_from(max_id) do
    tweets = fetch_tweets(max_id)
    number_of_tweets = Enum.count(tweets)
    IO.puts "fetch_and_deleting #{number_of_tweets} tweets."

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
    IO.puts date
    last_tweet_id
  end
end
