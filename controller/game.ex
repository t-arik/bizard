defmodule Bizard.Controller.Game do
  require Bizard.Game
  require Bizard.Card
  alias Bizard.Game
  use Plug.Router

  plug(Bizard.Plug.Auth, redirect: "/register")

  plug(:match)
  plug(:dispatch)

  get "/" do
    %{game: game, player: player} = conn.assigns

    view =
      game
      |> Bizard.Template.game(player)
      |> Bizard.Template.index()

    send_resp(conn, 200, view)
  end

  post "/start" do
    game = conn.assigns.game

    if Game.is_ready_to_deal(game) == false do
      conn
      |> send_resp(403, "The game requires more players")
    else
      game =
        game
        |> Game.start_round()
        |> Game.deal()

      conn
      |> assign(:game, game)
      |> send_resp(200, "")
    end
  end

  post "/set-trump/:suit" do
    %{game: game, player: player} = conn.assigns

    if suit != :none and Game.get_active_player(game) == player.name do
      suit =
        case suit do
          "red" -> Bizard.Card.red()
          "blue" -> Bizard.Card.blue()
          "green" -> Bizard.Card.green()
          "yellow" -> Bizard.Card.yellow()
          _ -> :none
        end

      game = Game.set_trump(game, suit)

      conn
      |> assign(:game, game)
      |> send_resp(200, "")
    else
      send_resp(conn, 400, "Invalid suit or not your turn.")
    end
  end

  post "/play-card/:card" do
    %{game: game, player: player} = conn.assigns

    if Game.get_active_player(game) == player.name do
      card = Bizard.Card.from_string(card)

      game =
        game
        |> Game.play_card(player, card)
        |> then(fn
          game when Game.is_queue_empty(game) -> Game.conclude_trick(game)
          game -> game
        end)

      conn
      |> assign(:game, game)
      |> send_resp(200, "")
    else
      send_resp(conn, 400, "Not your turn")
    end
  end

  post "/bid/:bid" do
    %{game: game, player: player} = conn.assigns

    if Game.get_active_player(game) == player.name do
      game =
        game
        |> Game.bid(player, String.to_integer(bid))
        |> then(fn
          game when Game.is_queue_empty(game) -> Game.start_playing(game)
          game -> game
        end)

      conn
      |> assign(:game, game)
      |> send_resp(200, "")
    else
      send_resp(conn, 400, "Not your turn")
    end
  end
end
