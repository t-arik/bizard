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

  def deal_cards(game = %Game{state: :waiting}) do
    [top_card | deck] = Deck.new()
    stack = Stack.new(top_card)

    # give the players cards
    players =
      game.players
      |> Enum.zip(Enum.chunk_every(deck, game.round))
      |> Enum.map(fn {player, hand} -> Player.set_hand(player, hand) end)

    %Game{game | state: :playing, stack: stack, players: players, queue: []}
  end

  def set_trump(game = %Game{stack: %Stack{trump: :pending}}, suit) do
    stack = Stack.set_trump(game.stack, suit)
    %Game{game | stack: stack}
  end

  def play_card(
        game = %Game{state: :playing, queue: [player | queue_rest]},
        player = %Player{},
        card = %Card{}
      ) do
    # TODO check if player is part of the game
    with {:owns_card, true} <- {:owns_card, Enum.member?(player.hand, card)},
         {:legal, true} <- {:legal, card in legal_moves(game.stack, player)} do
      stack = Stack.play(game.stack, card)

      players =
        Enum.map(game.players, fn p ->
          if p.name == player.name do
            Player.remove_card(player, card)
          else
            p
          end
        end)

      %Game{game | stack: stack, queue: queue_rest, players: players}
    else
      {:owns_card, false} -> {:error, :does_not_own_card}
      {:legal, false} -> {:error, :illegal_move}
    end
  end

  def play_card(%Game{state: :playing}, %Player{}, %Card{}) do
    {:error, :game_not_started}
  end

  def legal_moves(stack = %Stack{}, player = %Player{}) do
    trump = stack.trump
    to_serve = stack.to_serve

    moves =
      Enum.filter(player.hand, fn
        Card.wizard() -> true
        Card.jester() -> true
        %Card{suit: ^trump} -> true
        %Card{suit: ^to_serve} -> true
        _ -> false
      end)

    if Enum.empty?(moves), do: player.hand, else: moves
  end

  def conclude_trick(game = %Game{}) do
    # TODO
    game
  end

  # ensure a sitting order
  # keep track of the active player and the order
  # evaluate the trick winner and distribute the points
  # repeat
end
