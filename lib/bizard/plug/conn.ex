defmodule Bizard.Plug.Conn do
  def get_game(conn) do
    conn.assigns[:game]
  end

  def set_game(conn, game) do
    Plug.Conn.assign(conn, :game, game)
  end
end
