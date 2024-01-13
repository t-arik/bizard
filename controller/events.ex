defmodule Bizard.Controller.Events do
  @moduledoc """
  Thid Plug is responsible for registering and distributing out SSE
  """
  use Plug.Router
  alias Bizard.Component

  plug(:match)
  plug(:dispatch)

  get "/" do
    conn =
      conn
      |> put_resp_header("cache-control", "no-cache")
      |> put_resp_header("connection", "keep-alive")
      |> put_resp_header("content-type", "text/event-stream")
      |> send_chunked(200)

    :ok = Component.EventPubSub.subscribe(self())
    event_loop(conn)
  end

  def event_loop(conn) do
    {:ok, conn} =
      receive do
        {:event, event} ->
          Plug.Conn.chunk(conn, "event: #{event}\ndata: noop\n\n")
      end

    event_loop(conn)
  end
end
