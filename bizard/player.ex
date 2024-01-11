defmodule Bizard.Player do
  @moduledoc """
  This module represents a Bizard player
  """
  alias Bizard.Card
  alias Bizard.Player

  @type t() :: %Bizard.Player{}
  @enforce_keys [:name]
  defstruct [:name, :bid, points: 0, hand: [], tricks: []]

  @spec new(binary()) :: t()
  def new(name) when is_binary(name) do
    %Player{name: name}
  end

  @spec set_hand(t(), [Card.t()]) :: t()
  def set_hand(player = %Player{}, cards) do
    %Player{player | hand: cards}
  end

  @spec remove_card(t(), Card.t()) :: t()
  def remove_card(player = %Player{}, card = %Card{}) do
    %Player{player | hand: Enum.reject(player.hand, &(&1 == card))}
  end

  @spec add_trick(t(), [Card.t()]) :: t()
  def add_trick(player = %Player{}, trick) do
    %Player{player | tricks: [trick | player.tricks]}
  end

  @spec add_points(t(), integer()) :: t()
  def add_points(player = %Player{}, points) when is_integer(points) do
    %Player{player | points: player.points + points}
  end

  @spec set_bid(t(), integer()) :: t()
  def set_bid(player = %Player{}, bid) when is_integer(bid) do
    %Player{player | bid: bid}
  end

  @spec clear_bid(t()) :: t()
  def clear_bid(player = %Player{}) do
    %Player{player | bid: nil}
  end

  @spec clear_tricks(t()) :: t()
  def clear_tricks(player = %Player{}) do
    %Player{player | tricks: []}
  end
end
