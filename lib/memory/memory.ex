defmodule Memory.Game do
  use Agent

  @doc """
  gets the view of the game for the client, with current state
  """
  def client_view(game) do
    %{
      clicks: 0,
      cards: [],
      locked: false,
      pairs: 0,
      lastCard: nil,
    }
  end

  @doc """
  Starts agent
  """
  def start_link _args do
    Agent.start_link fn -> Map.new end, name: __MODULE__
  end

  def flip(game, value) do
    IO.puts("clicked")
    #IO.inspect(game)
  end

  #TODO
  def new(id) do
   Agent.get_and_update __MODULE__, fn lobby ->
     if not Map.has_key? lobby, id do
       { :ok, Map.put(lobby, id, initial_state()) }
     else
       { :already_exists, lobby }
     end
   end
  end

  defp initial_state do
    %{
      :clicks => 0,
      :cards => [],
      :locked => false,
      :pairs => 0,
      :lastCard => nil,
    }
  end
end
