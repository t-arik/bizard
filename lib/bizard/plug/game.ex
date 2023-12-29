defmodule Bizard.Plug.Game do
  use Plug.Router
  import Plug.Conn
  alias Bizard.Templates

  plug(
    Bizard.Plug.CookieAuth,
    redirect: "/register",
    required_cookie: "user-id"
  )

  plug(:match)
  plug(:dispatch)

  get "/" do
    send_resp(conn,
      200,
      conn
      |> Bizard.Plug.Conn.get_game()
      |> Templates.game()
      |> Templates.index()
    )
  end
end
