defmodule Bizard.Player do
  alias Bizard.Card
  alias Bizard.Player
  @enforce_keys [:name]
  defstruct [:name, :bid, points: 0, hand: [], tricks: []]

  def new(name) when is_binary(name) do
    %Player{name: name}
  end

  @spec set_hand(%Player{}, [%Card{}]) :: %Player{}
  def set_hand(player = %Player{}, cards) do
    %Player{player | hand: cards}
  end

  def remove_card(player = %Player{}, card = %Card{}) do
    %Player{player | hand: Enum.reject(player.hand, &(&1 == card))}
  end

  def add_trick(player = %Player{}, trick) do
    %Player{player | tricks: [trick | player.tricks]}
  end

  def add_points(player = %Player{}, points) when is_integer(points) do
    %Player{player | points: player.points + points}
  end

  def set_bid(player = %Player{}, bid) when is_integer(bid) do
    %Player{player | bid: bid}
  end
end
