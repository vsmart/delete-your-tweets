defmodule DeleteYourTweets.SessionController do
  use DeleteYourTweets.Web, :controller

  def create(conn, _params) do
    # TODO: PR to Extwitter to make request_token return {:ok, token}
    try do
      callback_url = System.get_env("CALLBACK_URL")
      token = ExTwitter.request_token(callback_url)
      {:ok, authenticate_url} = ExTwitter.authenticate_url(token.oauth_token)
      redirect(conn, external: authenticate_url)
    catch
      _,_ ->
        conn
        |> put_flash(:error, "Could not sign you into Twitter. 💩")
        |> redirect(to: "/")
    end
  end

  def callback(conn, %{"oauth_token"=> oauth_token, "oauth_verifier" => oauth_verifier}) do
    {:ok, access_token} = ExTwitter.access_token(oauth_verifier, oauth_token)
    ExTwitter.configure(
      consumer_key: System.get_env("TWITTER_CONSUMER_KEY"),
      consumer_secret: System.get_env("TWITTER_CONSUMER_SECRET"),
      access_token: access_token.oauth_token,
      access_token_secret: access_token.oauth_token_secret)

    conn
    |> put_session(:screen_name, access_token.screen_name)
    |> redirect(to: "/")
  end

  def delete(conn, _params) do
    DeleteYourTweets.configure_twitter_client

    conn
    |> delete_session(:screen_name)
    |> put_flash(:info, "You signed out. Bye 👋")
    |> redirect(to: "/")
  end
end
