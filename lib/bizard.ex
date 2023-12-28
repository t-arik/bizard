defmodule Bizard do
  alias Bizard.Player

  defstruct [
    :stack,
    players: [],
    round: 0,
    state: :waiting
  ]

  def new() do
    %Bizard{}
  end

  def add_player(game = %Bizard{state: :waiting}, player = %Player{}) do
    %Bizard{game | players: [player | game.players]}
  end
end
