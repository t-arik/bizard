defmodule Bizard.Controller.Game do
  use Plug.Router

  plug( Bizard.Plug.Auth, redirect: "/register")

  plug(:match)
  plug(:dispatch)

  get "/" do
    send_resp(conn,
      200,
      conn.assigns.game
      |> Bizard.Template.game()
      |> Bizard.Template.index()
    )
  end
end
