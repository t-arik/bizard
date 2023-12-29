defmodule Bizard.GameState do
  use GenServer
  import Plug.Conn

  def start_link() do
    GenServer.start_link(__MODULE__, {Bizard.Game.new(), []})
  end

  def subscribe(conn = %Plug.Conn{}) do
    GenServer.cast(__MODULE__, {:subscribe, conn})
  end

  def publish(event) do
    subs = GenServer.call(__MODULE__, :get_subs)
    Enum.each(subs, fn conn -> chunk(conn, "event: #{event}\n") end)
  end

  @impl true
  def init(state) do
    {:ok, state}
  end

  @impl true
  def handle_call(:get_game, _from, state = {game, _subs}) do
    {:reply, game, state}
  end

  @impl true
  def handle_call(:get_subs, _from, state = {_game, subs}) do
    {:reply, subs, state}
  end

  @impl true
  def handle_cast({:set_game, game}, {_, subs}) do
    {:noreply, {game, subs}}
  end

  @impl true
  def handle_cast({:subscribe, conn = %Plug.Conn{}}, {game, subs}) do
    {:noreply, {game, [conn | subs]}}
  end
end
