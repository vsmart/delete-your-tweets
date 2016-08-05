defmodule DeleteYourTweets.PageView do
  use DeleteYourTweets.Web, :view

  def current_user_else_default(conn) do
    if user = current_user?(conn) do
      user
    else
      "______"
    end
  end

  def current_user?(conn) do
    Plug.Conn.get_session(conn, :screen_name)
  end
end
