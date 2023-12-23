defmodule Bizard.Stack do
  require Bizard.Card
  alias Bizard.Card
  alias Bizard.Stack

  @enforce_keys [:first_card, :trump]
  defstruct [
    :first_card,
    :trump,
    current_trick: [],
    tricks: []
  ]

  def new(card = Card.jester()) do
    %Stack{first_card: card, trump: :none}
  end

  def new(card = Card.wizard()) do
    %Stack{first_card: card, trump: :none}
  end

  def new(card = %Card{color: color}) do
    %Stack{first_card: card, trump: color}
  end

  def set_trump(stack = %Stack{first_card: Card.wizard()}, trump) do
    # TODO check if trump color is valid e.g. :red, :blue, ...
    %Stack{stack | trump: trump}
  end

  def has_trump?(%Stack{trump: :none}) do
    false
  end

  def has_trump?(%Stack{}) do
    true
  end

  def play(%Stack{first_card: Card.wizard(), trump: :none}) do
    raise "The first card is a wizard. Choose a trump before playing"
  end

  def play(stack = %Stack{trump: :none}, card = %Card{})
      when card not in [Card.wizard(), Card.jester()] do
    stack = %Stack{stack | trump: card.color}
    play(stack, card)
  end

  def play(stack = %Stack{}, card = %Card{}) do
    trick = stack.current_trick ++ [card]
    %Stack{stack | current_trick: trick}
  end

  def trick_winner(stack = %Stack{}) when length(stack.current_trick) > 0 do
    stack.current_trick
    |> Enum.with_index()
    |> Enum.sort(fn {card1, _idx1}, {card2, _idx2} ->
      higher?(stack.trump, card1, card2)
    end)
    |> hd()
  end

  defp higher?(_trump, Card.wizard(), %Card{}) do
    true
  end

  defp higher?(_trump, %Card{}, Card.wizard()) do
    false
  end

  defp higher?(_trump, Card.jester(), %Card{}) do
    true
  end

  defp higher?(_trump, %Card{}, Card.jester()) do
    false
  end

  defp higher?(_trump, %Card{color: c, value: v1}, %Card{color: c, value: v2}) do
    v1 >= v2
  end

  defp higher?(trump, %Card{color: trump}, %Card{}) do
    true
  end

  defp higher?(trump, %Card{}, %Card{color: trump}) do
    false
  end

  defp higher?(_trump, %Card{value: v1}, %Card{value: v2}) do
    v1 >= v2
  end
end
