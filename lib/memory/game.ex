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

  def flip(game, value) do
    IO.puts("cardValue: ")
    IO.puts(value)
    #IO.inspect(game)
  end

  #TODO
  def inspect_game(name) do
   Agent.get_and_update __MODULE__, fn lobby ->
     if not Map.has_key? lobby, name do
       { new_state, Map.put(lobby, name, new_state) }
     else
       {Map.get(lobby, name), lobby}
       #{ already_exists, lobby }
     end
   end
  end

  defp new_state do
#    init = %{
    %{
      :clicks => 0,
      :cards => [],
      :locked => false,
      :pairs => 0,
      :lastCard => nil,
    }
  end
end
