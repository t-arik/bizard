defmodule Bizard.Game do
  require Bizard.Card
  alias Bizard.Card
  alias Bizard.Deck
  alias Bizard.Game
  alias Bizard.Player
  alias Bizard.Stack

  defstruct [
    :stack,
    players: [],
    # Determines whose turn it is
    queue: [],
    round: 1,
    state: :waiting
  ]

  @spec new() :: %Game{}
  def new() do
    %Game{}
  end

  def add_player(game = %Game{state: :waiting}, player = %Player{}) do
    %Game{game | players: [player | game.players]}
  end

  def start_trick(game = %Game{state: :waiting}) do
    # create deck and stack
    [top_card | deck] = Deck.new()
    stack = Stack.new(top_card)

    # give the players cards
    chunks = Enum.chunk_every(deck, game.round)

    players =
      game.players
      |> Enum.zip(chunks)
      |> Enum.map(fn {player, hand} -> Player.set_hand(player, hand) end)

    state = if top_card == Card.wizard(), do: :choosing_color, else: :playing

    %Game{game | state: state, stack: stack, players: players, queue: []}
  end

  def set_trump(game = %Game{state: :choosing_color}, color) do
    stack = Stack.set_trump(game.stack, color)
    %Game{game | state: :playing, stack: stack}
  end

  def play_card(
        game = %Game{state: :playing, queue: [player | queue]},
        player = %Player{},
        card = %Card{}
      ) do
    # TODO check if player is part of the game
    with {:owns_card, true} <- {:owns_card, Enum.member?(player.hand, card)},
         {:legal, true} <- {:legal, card in legal_moves(game.stack, player)} do
      stack = Stack.play(card)

      players =
        Enum.map(game.players, fn p ->
          if p.name == player.name do
            Player.remove_card(player, card)
          else
            p
          end
        end)

      %Game{game | stack: stack, queue: queue, players: players}
    else
      {:owns_card, false} -> {:error, :does_not_own_card}
      {:legal, false} -> {:error, :illegal_move}
    end
  end

  def play_card(%Game{state: :playing}, %Player{}, %Card{}) do
    {:error, :not_active}
  end

  defp legal_moves(stack = %Stack{}, player = %Player{}) do
    trump = stack.trump

    if Stack.has_trump?(trump) do
      Enum.filter(player.hand, fn
        Card.wizard() -> true
        Card.jester() -> true
        %Card{color: ^trump} -> true
        %Card{color: ^trump} -> false
      end)
    else
      player.hand
    end
  end

  # start the game
  # ensure a sitting order
  # start the trick
  # give the player cards
  # keep track of the active player and the order
  # evaluate the trick winner and distribute the points
  # repeat
end
