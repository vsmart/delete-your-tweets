defmodule DeleteYourTweets.PageController do
  use DeleteYourTweets.Web, :controller

  def index(conn, _params) do
    render conn, "index.html", step: :one
  end
end
