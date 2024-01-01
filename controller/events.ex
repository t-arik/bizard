defmodule Bizard.Controller.Events do
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

    :ok = Bizard.Component.EventPubSub.subscribe(self())
    event_loop(conn)
  end

  def event_loop(conn) do
    {:ok, conn} = receive do
      {:event, event} ->
        IO.inspect("Got event #{event}")
        Plug.Conn.chunk(conn, "event: #{event}\ndata: noop\n\n")
    end
    event_loop(conn)
  end

  # TODO 404 route
end
