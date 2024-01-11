defmodule Bizard.Deck do
  @moduledoc """
  A list of all cards which can be drawn by the player
  """
  alias Bizard.Card
  require Bizard.Card

  @spec new :: [Bizard.Card.t()]
  def new do
    suits = [
      Card.red(),
      Card.blue(),
      Card.green(),
      Card.yellow()
    ]

    cards =
      for suit <- suits, value <- 1..13 do
        %Card{suit: suit, value: value}
      end

    wizards = List.duplicate(Card.wizard(), 4)
    jesters = List.duplicate(Card.jester(), 4)
    Enum.shuffle(cards ++ wizards ++ jesters)
  end
end
