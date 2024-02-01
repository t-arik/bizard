defmodule Bizard.Controller.Register do
  @moduledoc """
  The Plug responsible for registering a new user
  """
  use Plug.Router
  alias Bizard.Game
  alias Bizard.Player
  alias Bizard.Template

  plug(Plug.Parsers, parsers: [:urlencoded])
  plug(:match)
  plug(:dispatch)

  get "/" do
    conn = fetch_cookies(conn)
    user = Map.get(conn.cookies, "user-id")
    game = Bizard.Component.Game.get()

    if user != nil and Game.get_player(game, user) != nil do
      conn
      |> put_resp_header("location", "/game")
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
      name = Plug.HTML.html_escape(name)
      player = Player.new(name)

      game = Game.add_player(conn.assigns.game, player)

      conn
      |> assign(:game, game)
      |> put_resp_cookie("user-id", name)
      |> put_resp_header("location", "/game")
      |> send_resp(302, "")
    else
      conn |> send_resp(400, "Missing 'name' parameter")
    end
  end
end
