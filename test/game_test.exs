defmodule GameTest do
  alias Bizard.Game
  alias Bizard.Player
  use ExUnit.Case

  test "players join and start game" do
    game =
      Game.new()
      |> Game.add_player(Player.new("player1"))
      |> Game.add_player(Player.new("player2"))
      |> Game.add_player(Player.new("player3"))
      |> Game.add_player(Player.new("player4"))

    assert game.state == :waiting
    game = Game.deal_cards(game)
    assert game.state == :playing or game.state == :choosing_color
  end
end
