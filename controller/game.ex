defmodule Bizard.Controller.Game do
  use Plug.Router

  plug(Bizard.Plug.Auth, redirect: "/register")

  plug(:match)
  plug(:dispatch)

  get "/" do
    send_resp(
      conn,
      200,
      conn.assigns.game
      |> Bizard.Template.game(conn.assigns.player)
      |> Bizard.Template.index()
    )
  end

  put "/start" do
    game = conn.assigns.game

    if game.state != :ready do
      conn
      |> Plug.Conn.send_resp(403, "The game requires more players")
    else
      game =
        game
        |> Bizard.Game.start_game()
        |> Bizard.Game.deal()

      conn
      |> assign(:game, game)
      |> Plug.Conn.send_resp(200, "")
    end
  end

  put "/play-card/:card" do
    conclude_if_all_played = fn
      game = %Bizard.Game{queue: []} -> Bizard.Game.conclude_trick(game)
      game -> game
    end

    card = Bizard.Card.from_string(card)

    game =
      conn.assigns.game
      |> Bizard.Game.play_card(conn.assigns.player, card)
      |> then(conclude_if_all_played)

    conn
    |> assign(:game, game)
    |> send_resp(200, "")
  end

  put "/bid/:bid" do
    start_if_all_bid = fn
      game = %Bizard.Game{queue: []} -> Bizard.Game.start_round(game)
      game -> game
    end

    game =
      conn.assigns.game
      |> Bizard.Game.bid(conn.assigns.player, String.to_integer(bid))
      |> then(start_if_all_bid)

    conn
    |> assign(:game, game)
    |> send_resp(200, "")
  end
end
