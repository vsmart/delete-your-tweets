defmodule DeleteYourTweets.TweetController do
  use DeleteYourTweets.Web, :controller

  def delete(conn, %{"older_than_months" => older_than_months}) do
    latest_tweet_id = get_latest_tweet_id
    fetch_and_delete_from(latest_tweet_id)

    conn
    |> put_flash(:info, "Deleted a bunch of your tweets. Wheee 🎉")
    |> redirect(to: "/")
  end

  defp get_latest_tweet_id  do
    [%ExTwitter.Model.Tweet{id: id}] = ExTwitter.user_timeline(count: 1)
    id
  end

  defp fetch_and_delete_from(max_id) do
    tweets = fetch_tweets(max_id)
    IO.puts "Fetched #{Enum.count(tweets)} tweets."
    delete_tweets(tweets)

    if Enum.count(tweets) > 0 do
      %ExTwitter.Model.Tweet{id: last_tweet_id} = List.last(tweets)
      fetch_and_delete_from(last_tweet_id)
    end
  end

  defp fetch_tweets(max_id) do
    ExTwitter.user_timeline(count: 3, max_id: max_id)
  end

  defp delete_tweets(tweets) do
    Enum.map(tweets,
      fn tweet ->
        ExTwitter.destroy_status(tweet.id)
      end)
  end
end
