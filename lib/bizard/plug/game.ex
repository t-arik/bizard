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
    conn
    |> send_resp(200, Templates.index(Templates.game()))
  end
end

