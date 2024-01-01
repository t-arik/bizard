defmodule Bizard.Component.Game do
  use Agent

  def start_link(_) do
    Agent.start_link(fn -> Bizard.Game.new() end, name: __MODULE__)
  end

  def set(game = %Bizard.Game{}) do
    Agent.cast(__MODULE__, fn _ -> game end)
  end

  def get do
    Agent.get(__MODULE__, & &1)
  end
end
