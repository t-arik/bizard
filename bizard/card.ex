defmodule Bizard.Card do
  @enforce_keys [:suit]
  defstruct [:suit, :value]

  defmacro red, do: :red
  defmacro blue, do: :blue
  defmacro green, do: :green
  defmacro yellow, do: :yellow
  defmacro wizard, do: quote(do: %Bizard.Card{suit: :wizard})
  defmacro jester, do: quote(do: %Bizard.Card{suit: :jester})

  def from_string(str) when is_binary(str) do
    # This is fucking cursed, I know.
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
    suit_str = String.capitalize(Atom.to_string(card.suit))
    suit_str <> " " <> Integer.to_string(card.value)
  end
end
