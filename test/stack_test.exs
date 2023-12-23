defmodule StackTest do
  alias Bizard.Stack
  alias Bizard.Card
  require Bizard.Card
  use ExUnit.Case

  test "first card color is trump" do
    card = %Card{color: :red, value: 2}
    stack = Stack.new(card)
    assert stack.trump == :red
  end

  test "no trump if first card is jester" do
    card = Card.jester()
    stack = Stack.new(card)
    assert stack.trump == :none
  end

  test "chosen trump if first card is wizard" do
    card = Card.wizard()
    stack = Stack.new(card)
    assert stack.trump == :none
    stack = Stack.set_trump(stack, :red)
    assert stack.trump == :red
  end

  test "wizard always wins" do
    stack =
      Stack.new(%Card{color: :red, value: 1})
      |> Stack.play(%Card{color: :red, value: 2})
      |> Stack.play(Card.wizard())
      |> Stack.play(%Card{color: :yellow, value: 13})
      |> Stack.play(Card.jester())

    assert Stack.trick_winner(stack) == {Card.wizard(), 1}
  end

  test "first wizard always wins" do
    stack =
      Stack.new(%Card{color: :red, value: 1})
      |> Stack.play(%Card{color: :red, value: 2})
      |> Stack.play(Card.wizard())
      |> Stack.play(%Card{color: :yellow, value: 13})
      |> Stack.play(Card.wizard())

    assert Stack.trick_winner(stack) == {Card.wizard(), 1}
  end

  test "higher card with trump color wins" do
    winner = %Card{color: :red, value: 10}

    stack =
      Stack.new(%Card{color: :red, value: 1})
      |> Stack.play(%Card{color: :red, value: 2})
      |> Stack.play(winner)
      |> Stack.play(%Card{color: :yellow, value: 13})
      |> Stack.play(%Card{color: :red, value: 9})

    assert Stack.trick_winner(stack) == {winner, 1}
  end

  test "higher card wins when no card is trump" do
    winner = %Card{color: :yellow, value: 13}

    stack =
      Stack.new(%Card{color: :blue, value: 1})
      |> Stack.play(%Card{color: :red, value: 2})
      |> Stack.play(%Card{color: :green, value: 10})
      |> Stack.play(winner)
      |> Stack.play(%Card{color: :red, value: 9})

    assert Stack.trick_winner(stack) == {winner, 2}
  end

  test "first jester wins if all cards are jesters" do
    stack =
      Stack.new(%Card{color: :blue, value: 1})
      |> Stack.play(Card.jester())
      |> Stack.play(Card.jester())
      |> Stack.play(Card.jester())
      |> Stack.play(Card.jester())

    assert Stack.trick_winner(stack) == {Card.jester(), 0}
  end
end
