defmodule MemoryWeb.GamesChannel do
  use MemoryWeb, :channel

  alias Memory.Game
  alias Memory.BackupAgent


  def join("games:" <> name, payload, socket) do
    {:ok, Game.inspect_game(name), socket}
  end
  
  #TODO handle flip messages, fix flipping
  def handle_in("flip", %{"flipped_card" => card}, socket) do
    "games:" <> name = socket.topic
    lobby = Game.flip(name, card)
    BackupAgent.put(name, lobby)
    new_view_state = lobby[name]
    broadcast! socket, "state_update", new_view_state
    {:noreply, socket}
  end

	#TODO handle reset messages

end
