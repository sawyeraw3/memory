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
      #TODO if last card isn't null, check match
      clickCount = state[:clicks] + 1
      state = Map.replace state, :clicks, clickCount
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
      :cards => new_cards(),
      :locked => false,
      :pairs => 0,
      :lastCard => nil,
    }
    #Map.merge(init, (Enum.reduce new_cards, Map.new, &Map.put(&2, &1, false)))
  end

  defp new_card(letter) do
    %{
      value: letter,
      matched: false,
      isPair: false,
      flipped: false
    }
  end

  defp new_cards do
    vals = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H']
    vals = Enum.shuffle(vals)
    cards = Enum.map(vals, fn x -> new_card(x) end)
    #IO.inspect(Enum.fetch(cards, 0))
  end
end
