defmodule Bizard.Stack do
  require Bizard.Card
  alias Bizard.Card
  alias Bizard.Stack
  alias Bizard.Player

  @enforce_keys [:trump]
  defstruct [
    :trump,
    to_serve: :none,
    current_trick: [],
    tricks: []
  ]

  def new(Card.jester()) do
    {:ok, %Stack{trump: :none}}
  end

  def new(Card.wizard()) do
    {:pending, %Stack{trump: :pending}}
  end

  def new(%Card{suit: suit}) do
    {:ok, %Stack{trump: suit}}
  end

  def set_trump(stack = %Stack{trump: :pending}, trump) do
    # TODO check if trump suit is valid e.g. :red, :blue, ...
    %Stack{stack | trump: trump}
  end

  def play(%Stack{trump: :pending}, %Card{}, %Player{}) do
    raise "The first card was a wizard. Choose a trump before playing"
  end

  def play(stack = %Stack{to_serve: :none}, card = %Card{}, player = %Player{})
      when card not in [Card.wizard(), Card.jester()] do
    stack = %Stack{stack | to_serve: card.suit}
    play(stack, card, player)
  end

  def play(stack = %Stack{trump: :none}, card = %Card{}, player = %Player{})
      when card not in [Card.wizard(), Card.jester()] do
    stack = %Stack{stack | trump: card.suit}
    play(stack, card, player)
  end

  def play(stack = %Stack{}, card = %Card{}, player = %Player{}) do
    trick = stack.current_trick ++ [{card, player}]
    %Stack{stack | current_trick: trick}
  end

  def trick_winner(stack = %Stack{}) when length(stack.current_trick) > 0 do
    stack.current_trick
    |> Enum.sort(fn {card1, _player1}, {card2, _player2} ->
      higher?(stack.trump, card1, card2)
    end)
    |> hd()
    |> then(fn {_card, player} -> player end)
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

  def reset(stack = %Stack{}) do
    %Stack{
      stack
      | current_trick: [],
        tricks: [stack.current_trick | stack.tricks]
    }
  end
end
