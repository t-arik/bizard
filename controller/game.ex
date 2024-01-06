defmodule Bizard.Controller.Game do
  require Bizard.Card
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

    if game.state != :ready do
      conn
      |> send_resp(403, "The game requires more players")
    else
      game =
        game
        |> Bizard.Game.start_game()
        |> Bizard.Game.deal()

      conn
      |> assign(:game, game)
      |> send_resp(200, "")
    end
  end

  post "/set-trump/:suit" do
    %{game: game, player: player} = conn.assigns

    if suit != :none and Bizard.Game.get_active_player(game) == player.name do
      suit =
        case suit do
          "red" -> Bizard.Card.red()
          "blue" -> Bizard.Card.blue()
          "green" -> Bizard.Card.green()
          "yellow" -> Bizard.Card.yellow()
          _ -> :none
        end

      game = Bizard.Game.set_trump(game, suit)

      conn
      |> assign(:game, game)
      |> send_resp(200, "")
    else
      send_resp(conn, 400, "Invalid suit or not your turn.")
    end
  end

  post "/play-card/:card" do
    %{game: game, player: player} = conn.assigns

    if Bizard.Game.get_active_player(game) == player.name do
      conclude_if_all_played = fn
        game = %Bizard.Game{queue: []} -> Bizard.Game.conclude_trick(game)
        game -> game
      end

      card = Bizard.Card.from_string(card)

      game =
        game
        |> Bizard.Game.play_card(player, card)
        |> then(conclude_if_all_played)

      conn
      |> assign(:game, game)
      |> send_resp(200, "")
    else
      send_resp(conn, 400, "Not your turn")
    end
  end

  post "/bid/:bid" do
    %{game: game, player: player} = conn.assigns

    if Bizard.Game.get_active_player(game) == player.name do
      start_if_all_bid = fn
        game = %Bizard.Game{queue: []} -> Bizard.Game.start_round(game)
        game -> game
      end

      game =
        game
        |> Bizard.Game.bid(player, String.to_integer(bid))
        |> then(start_if_all_bid)

      conn
      |> assign(:game, game)
      |> send_resp(200, "")
    else
      send_resp(conn, 400, "Not your turn")
    end
  end
end
