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
    forward "/.well-known/acme-challenge/x_1tS_p2048TkqytLvqDL_QhZcqsSzw_czGbj9UUFrY", CertRouter
  end
end

defmodule DeleteYourTweets.CertRouter do
  use Plug.Router
  plug :match
  plug :dispatch

  match _ do
    send_resp(conn, 200, "x_1tS_p2048TkqytLvqDL_QhZcqsSzw_czGbj9UUFrY.Pxb-kY88ER7-wv0yEJZDHNanvjjXi4A-Xfcb-1Ejwuo")
  end
end
