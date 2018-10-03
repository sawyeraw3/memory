defmodule Memory.Agent do
  # Based on Registry docs.
  use Agent

  def start_link() do
    Agent.start_link(fn -> 0 end, name: __MODULE__)
  end

  def inc() do
    Agent.update(__MODULE__, &(&1 + 1))
  end

  def get() do
    Agent.get(__MODULE__, &(&1))
  end
end
