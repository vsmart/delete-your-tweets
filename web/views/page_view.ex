defmodule DeleteYourTweets.PageView do
  use DeleteYourTweets.Web, :view

  def current_user_else_default(conn) do
    if user = current_user?(conn) do
      user
    else
      "________"
    end
  end

  def current_user?(conn) do
    Plug.Conn.get_session(conn, :screen_name)
  end

  def show_active_or_inactive_div(step, current_step) do
    if step == current_step do
      "step-active"
    else
      "step-inactive"
    end
  end
end
