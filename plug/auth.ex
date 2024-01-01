defmodule Bizard.Plug.Auth do
  import Plug.Conn

  def init(opts) do
    opts
  end

  def call(conn, redirect: url) do
    conn = fetch_cookies(conn)
    username = Map.get(conn.cookies, "user-id")

    if username != nil do
      player = Bizard.Component.Game.get() |> Bizard.Game.get_player(username)

      conn
      |> assign(:username, username)
      |> assign(:player, player)
    else
      conn
      |> put_resp_header("location", url)
      |> send_resp(302, "")
      |> halt()
    end
  end
end
