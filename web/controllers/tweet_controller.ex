defmodule DeleteYourTweets.TweetController do
  use DeleteYourTweets.Web, :controller

  def delete(conn, %{"older_than_months" => older_than_months}) do
    max_id = get_latest_tweet_id

    conn
    |> put_flash(:info, "last tweet id is #{max_id}. 🎉")
    |> redirect(to: "/")
  end

  defp get_latest_tweet_id  do
    [%ExTwitter.Model.Tweet{id: id}] = ExTwitter.user_timeline(count: 1)
    id
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
