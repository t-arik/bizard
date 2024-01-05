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
    round: 0,
    state: :waiting
  ]

  @spec new() :: %Game{}
  def new() do
    %Game{}
  end

  def add_player(game = %Game{state: :waiting}, player = %Player{}) do
    game = %Game{game | players: [player | game.players]}

    if length(game.players) >= 2 do
      %Game{game | state: :ready}
    else
      game
    end
  end

  def get_player(game = %Game{}, name) when is_binary(name) do
    game.players
    |> Enum.find(fn p -> p.name == name end)
  end

  defp update_player(game = %Game{}, new_player = %Player{}) do
    players =
      Enum.map(game.players, fn player ->
        if player.name == new_player.name do
          new_player
        else
          player
        end
      end)

    %Game{game | players: players}
  end

  def start_game(game = %Game{state: :ready}) do
    %Game{game | round: 1, state: :dealing}
    |> set_playing_order(hd(game.players))
  end

  defp set_playing_order(game = %Game{}, first_player = %Player{}) do
    idx =
      Enum.find_index(game.players, fn player = %Player{} ->
        player.name == first_player.name
      end)

    {left, right} =
      game.players
      |> Enum.map(fn player -> player.name end)
      |> Enum.split(idx)

    %Game{game | queue: right ++ left}
  end

  def deal(game = %Game{state: :dealing}) do
    [top_card | deck] = Deck.new()

    players =
      game.players
      |> Enum.zip(Enum.chunk_every(deck, game.round))
      |> Enum.map(fn {player, hand} -> Player.set_hand(player, hand) end)

    game = %Game{game | players: players}

    case Stack.new(top_card) do
      {:ok, stack} -> %Game{game | state: :bidding, stack: stack}
      {:pending, stack} -> %Game{game | state: :trump_pending, stack: stack}
    end
  end

  def set_trump(game = %Game{stack: %Stack{trump: :pending}}, suit) do
    stack = Stack.set_trump(game.stack, suit)
    %Game{game | stack: stack, state: :playing}
  end

  def bid(
    game = %Game{state: :bidding, queue: [name | rest]},
    player = %Player{name: name, bid: nil},
    bid
  ) do
    game = update_player(game, Player.set_bid(player, bid))
    %Game{game | queue: rest}
  end

  def start_round(game = %Game{state: :bidding}) do
    if Enum.all?(game.players, fn player -> player.bid != nil end) do
      %Game{game | state: :playing}
      |> set_playing_order(hd(game.players))
    end
  end

  def play_card(
    game = %Game{state: :playing, queue: [name | rest]},
    player = %Player{name: name},
    card = %Card{}
  ) do
    with {:owns_card, true} <- {:owns_card, Enum.member?(player.hand, card)},
      {:legal, true} <- {:legal, card in legal_moves(game.stack, player)} do
      stack = Stack.play(game.stack, card, player)

      game = update_player(game, Player.remove_card(player, card))

      %Game{game | stack: stack, queue: rest}
    else
      {:owns_card, false} -> {:error, :does_not_own_card}
      {:legal, false} -> {:error, :illegal_move}
    end
  end

  defp legal_moves(stack = %Stack{}, player = %Player{}) do
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

  def conclude_trick(game = %Game{queue: [], state: :playing}) do
    player =
      game.stack
      |> Stack.trick_winner()
      |> Player.add_trick(game.stack.current_trick)

    game =
      game
      |> update_player(player)
      |> then(fn game -> %Game{game | stack: Stack.reset(game.stack)} end)

    if game.round == length(game.stack.tricks) do
      %Game{game | state: :round_ended}
      |> conclude_round()
    else
      %Game{game | state: :playing}
      |> set_playing_order(player)
    end
  end

  def conclude_round(game = %Game{}) do
    game
    # TODO reset bids and remove tricks from player
  end
end
