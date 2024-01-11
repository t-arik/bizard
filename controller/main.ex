defmodule Bizard.Controller.Main do
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
    if conn.assigns.game != conn.assigns.initial_game do
      Bizard.Component.Game.set(conn.assigns.game)
      Bizard.Component.EventPubSub.publish("game-update")
    end

    conn
  end

  forward("/register", to: Bizard.Controller.Register)
  forward("/events", to: Bizard.Controller.Events)
  forward("/game", to: Bizard.Controller.Game)
  forward("/", to: Bizard.Controller.Game)
end
