defmodule Bizard.Deck do
  alias Bizard.Card
  require Bizard.Card

  def new() do
    colors = [
      Card.red(),
      Card.blue(),
      Card.green(),
      Card.yellow()
    ]

    cards =
      for color <- colors, value <- 1..13 do
        %Card{color: color, value: value}
      end

    wizards = List.duplicate(Card.wizard(), 4)
    jesters = List.duplicate(Card.jester(), 4)
    Enum.shuffle(cards ++ wizards ++ jesters)
  end
end
