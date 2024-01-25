defmodule Bizard.Card do
  @moduledoc """
  This module represents a Card in Bizard.

  It also defines constants such as the possible card suits and special cards
  like the wizard and jester.
  """

  @type t() :: %Bizard.Card{}
  @enforce_keys [:suit]
  defstruct [:suit, :value]

  defmacro red, do: :red
  defmacro blue, do: :blue
  defmacro green, do: :green
  defmacro yellow, do: :yellow
  defmacro wizard, do: quote(do: %Bizard.Card{suit: :wizard})
  defmacro jester, do: quote(do: %Bizard.Card{suit: :jester})

  @spec from_string(binary()) :: t()
  def from_string(str) when is_binary(str) do
    # This is cursed, I know.
    cards = Bizard.Deck.new()
    Enum.find(cards, fn card -> to_string(card) == str end)
  end
end

defimpl String.Chars, for: Bizard.Card do
  require Bizard.Card

  def to_string(Bizard.Card.wizard()) do
    "Wizard"
  end

  def to_string(Bizard.Card.jester()) do
    "Jester"
  end

  def to_string(card = %Bizard.Card{}) do
    suit_str =
      card.suit
      |> Atom.to_string()
      |> String.capitalize()
      |> String.at(0)

    suit_str <> " " <> Integer.to_string(card.value)
  end
end
