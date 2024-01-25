defmodule Bizard.Controller.Main do
  @moduledoc """
  The entrypoint for all requests. Handles routing and game state updates
  """
  use Plug.Router

  plug(Plug.Logger)
  plug(Plug.Static, at: "assets", from: "static")
  plug(:provide_game_state)
  plug(:match)
  plug(:dispatch)
  plug(:update_game_state)

  defp provide_game_state(conn, _opts) do
    game = Bizard.Component.Game.get()

    conn
    |> Plug.Conn.assign(:game, game)
    |> Plug.Conn.assign(:initial_game, game)
  end

  defp update_game_state(conn, _opts) do
    alias Bizard.Component

    if conn.assigns.game != conn.assigns.initial_game do
      Component.Game.set(conn.assigns.game)
      Component.EventPubSub.publish("game-update")
      IO.inspect(conn.assigns.game)
    end

    conn
  end

  forward("/register", to: Bizard.Controller.Register)
  forward("/events", to: Bizard.Controller.Events)
  forward("/game", to: Bizard.Controller.Game)
  forward("/", to: Bizard.Controller.Game)
end
