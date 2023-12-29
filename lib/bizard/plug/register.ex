defmodule Bizard.Plug.Register do
  use Plug.Router
  import Bizard.Plug.Conn
  alias Bizard.Templates
  alias Bizard.Game

  plug(Plug.Parsers, parsers: [:urlencoded])
  plug(:match)
  plug(:dispatch)

  get "/" do
    conn
    |> send_resp(200, Templates.index(Templates.register()))
  end

  post "/" do
    name = Map.get(conn.body_params, "name")

    if name != nil do
      player = name |> Plug.HTML.html_escape() |> Bizard.Player.new()

      conn
      |> set_game(Game.add_player(get_game(conn), player))
      |> put_resp_cookie("user-id", name)
      |> put_resp_header("location", "/")
      |> send_resp(302, "")
    else
      conn |> send_resp(400, "Missing 'name' parameter")
    end
  end

  # TODO 404 match
end
