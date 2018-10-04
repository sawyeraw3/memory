defmodule Memory.Game do
  use Agent

  @doc """
  gets the view of the game for the client, with current state
  """
  def user_view(game) do
    %{
      clicks: game.clicks,
      cards: game.cards,
      locked: game.locked,
      pairs: game.pairs,
      lastCard: game.lastCard,
    }
  end

  @doc """
  Starts agent
  """
  def start_link _args do
    Agent.start_link fn -> Map.new end, name: __MODULE__
  end

  def flip(name, cardValue) do
    Agent.get_and_update __MODULE__, fn lobby -> 
      state = lobby[name]
      {state, Map.put(lobby, name, state)}
    end
  end

  #TODO
  def inspect_game(name) do
    Agent.get_and_update __MODULE__, fn lobby ->
      unless Map.has_key? lobby, name do
        state = clean_state()
        {state, Map.put(lobby, name, state)}
      else
        {Map.get(lobby, name), lobby}
      end
    end
  end

  defp clean_state do
    init = %{
      :clicks => 0,
      :cards => [],
      :locked => false,
      :pairs => 0,
      :lastCard => nil,
    }
    #Map.merge(init, (Enum.reduce cards, Map.new, &Map.put(&2, &1, false)))
  end

  defp cards do
    vals = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H']
  end
end
