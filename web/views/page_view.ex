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
    cond do
      (current_step == :one) -> "step-inactive"
      (current_step == :two) && (step == :two) -> "step-active"
      (current_step == :two) && (step == :three) -> "step-inactive"
      (current_step == :three) -> "step-active"
    end
  end
end
