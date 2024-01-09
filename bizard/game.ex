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

  defguard is_ready_to_deal(game) when game.state == :ready_to_deal
  defguard is_queue_empty(game) when game.queue == []

  @spec new() :: %Game{}
  def new() do
    %Game{}
  end

  def add_player(game = %Game{state: :waiting}, player = %Player{}) do
    game = %Game{game | players: [player | game.players]}

    if length(game.players) >= 2 do
      %Game{game | state: :ready_to_deal}
    else
      game
    end
  end

  def get_player(game = %Game{}, name) when is_binary(name) do
    game.players
    |> Enum.find(fn p -> p.name == name end)
  end

  def get_active_player(%Game{queue: []}) do
    :none
  end

  def get_active_player(%Game{queue: [name | _]}) do
    name
  end

  defp update_player(game = %Game{}, name, update) do
    players =
      Enum.map(game.players, fn player ->
        if player.name == name do
          update.(player)
        else
          player
        end
      end)

    %Game{game | players: players}
  end

  def start_round(game = %Game{round: nil}) do
    %Game{game | round: 1, state: :ready_to_deal}
    |> set_playing_order(hd(game.players))
  end

  def start_round(game = %Game{}) do
    %Game{game | round: game.round + 1, state: :ready_to_deal}
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

  def deal(game = %Game{state: :ready_to_deal}) when is_ready_to_deal(game) do
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

  def set_trump(game = %Game{state: :trump_pending}, suit) do
    stack = Stack.set_trump(game.stack, suit)
    %Game{game | stack: stack, state: :playing}
  end

  def bid(
        game = %Game{state: :bidding, queue: [name | rest]},
        player = %Player{name: name, bid: nil},
        bid
      ) do
    game = update_player(game, player.name, &Player.set_bid(&1, bid))
    %Game{game | queue: rest}
  end

  def start_playing(game = %Game{state: :bidding}) do
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

      game = update_player(game, player.name, &Player.remove_card(&1, card))

      {:ok, %Game{game | stack: stack, queue: rest}}
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
    winner =
      game.stack
      |> Stack.trick_winner()

    trick = game.stack.current_trick

    game =
      game
      |> update_player(winner.name, &Player.add_trick(&1, trick))
      |> then(fn game -> %Game{game | stack: Stack.reset(game.stack)} end)

    if game.round == length(game.stack.tricks) do
      %Game{game | state: :round_ended}
      |> conclude_round()
    else
      %Game{game | state: :playing}
      |> set_playing_order(winner)
    end
  end

  defp conclude_round(game = %Game{state: :round_ended}) do
    players =
      game.players
      |> Enum.map(fn player ->
        player
        |> Player.add_points(
          if player.bid == length(player.tricks) do
            20 + 10 * player.bid
          else
            -10
          end
        )
        |> Player.clear_bid()
        |> Player.clear_tricks()
      end)

    %Game{game | players: players, state: :ready_to_deal}
  end
end
