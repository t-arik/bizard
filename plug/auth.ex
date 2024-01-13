defmodule Bizard.Plug.Auth do
  @moduledoc """
  A Plug for ensuring that the user is authenticated

  The user is being redirected to the speicified route, in case the they are
  not yet authenticated. Once the user is authenticated this plug provides
  their username inside the connection's assign field
  """

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
