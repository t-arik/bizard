defmodule Bizard.Plug.SSE do
  use Plug.Router

  plug(:match)
  plug(:dispatch)

  get "/" do
    conn =
      conn
      |> put_resp_header("cache-control", "no-cache")
      |> put_resp_header("connection", "keep-alive")
      |> put_resp_header("content-type", "text/event-stream")
      |> send_chunked(200)

    :ok = Bizard.GameState.subscribe(conn)
  end

  # TODO 404 route
end
