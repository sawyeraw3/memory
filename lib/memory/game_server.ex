defmodule Memory.GameServer do
  use GenServer

  alias Memory.Game

  ## Client Interface
  def start_link(_args) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def view(game, user) do
    GenServer.call(__MODULE__, {:view, game, user})
  end

  def cooled(game, user) do
    GenServer.call(__MODULE__, {:cooled, game, user})
  end

  def replaceTiles(game, user, tile) do
    GenServer.call(__MODULE__, {:replaceTiles, game, user, tile})
  end

  ## Implementations
  def init(state) do
    {:ok, state}
  end

  def handle_call({:view, game, user}, _from, state) do
    gg = Map.get(state, game, Game.new)
    |>Game.new(user)
    {:reply, Game.client_view(gg, user), Map.put(state, game, gg)}
  end

  def handle_call({:replaceTiles, game, user, tile}, _from, state) do
    gg = Map.get(state, game, Game.new)
    |> Game.replaceTiles(user, tile)
    vv = Game.client_view(gg, user)
    {:reply, vv, Map.put(state, game, gg)}
  end

  def handle_call({:cooled, game, user}, _from, state) do
    gg = Map.get(state, game, Game.new)
    |> Game.cooled(user)
    vv = Game.client_view(gg, user)
    {:reply, vv, Map.put(state, game, gg)}
  end
end
