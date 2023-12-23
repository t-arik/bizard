defmodule Bizard.Player do
  alias Bizard.Card
  alias Bizard.Player
  @enforce_keys [:name]
  defstruct [:name, :bet, points: 0, hand: [], tricks: []]

  def new(name) when is_binary(name) do
    %Player{name: name}
  end

  def give_card(player = %Player{}, card = %Card{})  do
    %Player{player | hand: [card | player.hand]}
  end
end
