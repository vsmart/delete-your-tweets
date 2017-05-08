defmodule DeleteYourTweets.PageController do
  use DeleteYourTweets.Web, :controller

  def index(conn, _params) do
    DeleteYourTweets.configure_twitter_client

    conn
    |> delete_session(:screen_name)
    |> render("index.html", step: :one)
  end

  def about(conn, _params) do
    deletion_count = Repo.one(from td in DeleteYourTweets.TweetDeletion, select: count("*"))

    conn
    |> delete_session(:screen_name)
    |> render("about.html", deletion_count: deletion_count)
  end
end
