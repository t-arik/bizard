defmodule Bizard.Stack do
  require Bizard.Card
  alias Bizard.Card
  alias Bizard.Stack

  @enforce_keys [:trump]
  defstruct [
    :trump,
    to_serve: :none,
    current_trick: [],
    tricks: []
  ]

  def new(Card.jester()) do
    %Stack{trump: :none}
  end

  def new(Card.wizard()) do
    %Stack{trump: :pending}
  end

  def new(%Card{suit: suit}) do
    %Stack{trump: suit}
  end

  def set_trump(stack = %Stack{trump: :pending}, trump) do
    # TODO check if trump suit is valid e.g. :red, :blue, ...
    %Stack{stack | trump: trump}
  end

  def play(%Stack{trump: :pending}, %Card{}) do
    raise "The first card was a wizard. Choose a trump before playing"
  end

  def play(stack = %Stack{to_serve: :none}, card = %Card{})
    when card not in [Card.wizard(), Card.jester()] do
    stack = %Stack{stack | to_serve: card.suit}
    play(stack, card)
  end

  def play(stack = %Stack{trump: :none}, card = %Card{})
      when card not in [Card.wizard(), Card.jester()] do
    stack = %Stack{stack | trump: card.suit}
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

  defp higher?(trump, card1 = %Card{}, card2 = %Card{}) do
    case {trump, card1, card2} do
      {_, Card.wizard(), %Card{}} -> true
      {_, %Card{}, Card.wizard()} -> false
      {_, Card.jester(), %Card{}} -> true
      {_, %Card{}, Card.jester()} -> false
      {_, %Card{suit: s}, %Card{suit: s}} -> card1.value >= card2.value
      {t, %Card{suit: t}, %Card{}} -> true
      {t, %Card{}, %Card{suit: t}} -> false
      {_, %Card{}, %Card{}} -> card1.value >= card2.value
    end
  end
end
