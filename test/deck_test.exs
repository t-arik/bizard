defmodule DeckTest do
  use ExUnit.Case

  test "new deck card count" do
    deck = Bizard.Deck.new()
    assert length(deck) == 60
  end
end
