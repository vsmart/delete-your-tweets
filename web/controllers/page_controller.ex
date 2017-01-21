defmodule DeleteYourTweets.PageController do
  use DeleteYourTweets.Web, :controller

  def index(conn, _params) do
    DeleteYourTweets.configure_twitter_client

    conn
    |> delete_session(:screen_name)
    |> render("index.html", step: :one)
  end
end
