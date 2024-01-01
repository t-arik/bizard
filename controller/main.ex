# TODO use path utility for templates
# TODO check for XSS
# TODO use CSRFProtection
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
    Plug.Conn.assign(conn, :game, game)
  end

  defp update_game_state(conn, _opts) do
    Bizard.Component.Game.set(conn.assigns.game)
    Bizard.Component.EventPubSub.publish("game-update")
    IO.inspect(conn.assigns.game)
    conn
  end

  forward("/register", to: Bizard.Controller.Register)
  forward("/events", to: Bizard.Controller.Events)
  forward("/", to: Bizard.Controller.Game)
end

