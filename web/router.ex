defmodule DeleteYourTweets.Router do
  use DeleteYourTweets.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", DeleteYourTweets do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    post "/signin", SessionController, :create
    post "/signout", SessionController, :delete
    get "/callback", SessionController, :callback
    post "/tweets/delete", TweetController, :delete
  end
end
