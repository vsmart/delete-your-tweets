defmodule DeleteYourTweets.PageController do
  use DeleteYourTweets.Web, :controller

  def index(conn, _params) do
    DeleteYourTweets.configure_twitter_client
    deletion_count = Repo.one(from td in DeleteYourTweets.TweetDeletion, select: count("*"))

    conn
    |> delete_session(:screen_name)
    |> render("index.html", step: :one, deletion_count: deletion_count)
  end
end
