defmodule Bizard.Plug.Register do
  use Plug.Router
  alias Bizard.Templates

  plug(Plug.Parsers, parsers: [:urlencoded])
  plug(:match)
  plug(:dispatch)

  get "/register" do
    conn
    |> send_resp(200, Templates.index(Templates.register()))
    |> halt()
  end

  post "/register" do
    name = Map.get(conn.body_params, "name")

    if name != nil do
      conn
      |> put_resp_header("location", "/")
      |> put_resp_cookie("user-id", name)
      |> send_resp(302, "")
      |> halt()
    else
      conn |> send_resp(404, "Testing")
    end
  end
end
