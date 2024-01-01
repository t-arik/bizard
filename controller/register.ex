defmodule Bizard.Controller.Register do
  use Plug.Router
  alias Bizard.Template
  alias Bizard.Game
  alias Bizard.Player

  plug(Plug.Parsers, parsers: [:urlencoded])
  plug(:match)
  plug(:dispatch)

  get "/" do
    conn = fetch_cookies(conn)
    user = Map.get(conn.cookies, "user-id")

    if user != nil do
      conn
      |> put_resp_header("location", "/")
      |> send_resp(302, "")
      |> halt()
    else
      conn
      |> send_resp(200, Template.index(Template.register()))
    end
  end

  post "/" do
    name = Map.get(conn.body_params, "name")

    if name != nil do
      player = name |> Plug.HTML.html_escape() |> Player.new()

      conn
      |> assign(:game, Game.add_player(conn.assigns.game, player))
      |> put_resp_cookie("user-id", name)
      |> put_resp_header("location", "/")
      |> send_resp(302, "")
    else
      conn |> send_resp(400, "Missing 'name' parameter")
    end
  end

  # TODO 404 match
end
