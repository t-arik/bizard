defmodule Bizard.Component.EventPubSub do
  use Agent

  def start_link(subscriber) when is_list(subscriber) do
    Agent.start_link(fn -> subscriber end, name: __MODULE__)
  end
  
  def subscribe(pid) when is_pid(pid) do
    Agent.cast(__MODULE__, fn subs -> [pid | subs] end)
  end

  def publish(event) do
    subs = Agent.get(__MODULE__, &(&1))
    Enum.map(subs, fn pid ->
      send(pid, {:event, event})
    end)
  end
end
