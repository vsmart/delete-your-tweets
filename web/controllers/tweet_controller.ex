defmodule DeleteYourTweets.TweetController do
  use DeleteYourTweets.Web, :controller
  use Timex

  def delete(conn, %{"delete_from" => delete_from}) do
    from_date = Timex.now
    to_date = calculate_to_date(delete_from)

    to_tweet_id = get_newest_tweet_id()
    fetch_and_delete_from(to_date, to_tweet_id)


    info =  "From date: #{IO.inspect from_date} and to date: #{IO.inspect to_date}"
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

  defp get_newest_tweet_id()  do
    [%ExTwitter.Model.Tweet{id: id}] = ExTwitter.user_timeline(count: 1)
    id
  end

  defp older_than_date(date, tweet) do
    %ExTwitter.Model.Tweet{created_at: created_at} = tweet
    parsed_date = Timex.parse!(created_at, "%a %b %d %T %z %Y", :strftime)
    Timex.before?(parsed_date, date)
  end

  defp fetch_and_delete_from(date, max_id) do
    tweets = fetch_tweets(max_id)
    tweets_to_be_deleted = Enum.reject(tweets, fn tweet -> older_than_date(date, tweet)  end)

    tweets_to_be_deleted |> delete_tweets

    if !(reached_date_restriction(tweets, tweets_to_be_deleted))
      && !(fetched_all_tweets(tweets)) do
      last_id = last_tweet_id(tweets)
      fetch_and_delete_from(date, last_id)
    end
  end

  defp reached_date_restriction(tweets, tweets_to_be_deleted) do
    (Enum.count(tweets_to_be_deleted) < Enum.count(tweets))
  end

  defp fetched_all_tweets(tweets) do
    (Enum.count(tweets) == 0)
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
    %ExTwitter.Model.Tweet{id: id} = List.last(tweets)
    id
  end
end
