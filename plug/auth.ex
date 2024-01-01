defmodule Bizard.Plug.Auth do
  import Plug.Conn

  def init(opts) do
    opts
  end

  def call(conn, redirect: url) do
    conn = fetch_cookies(conn)
    user = Map.get(conn.cookies, "user-id")

    if user != nil do
      conn |> assign(:user, user)
    else
      conn
      |> put_resp_header("location", url)
      |> send_resp(302, "")
      |> halt()
    end
  end
end
