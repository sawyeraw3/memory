defmodule MemoryWeb.GamesChannel do
  use MemoryWeb, :channel

  alias Memory.Game
  alias Memory.BackupAgent

  def join("games:" <> name, payload, socket) do
    game = BackupAgent.get(name) || Game.inspect_game(name)
    socket = socket
    |> assign(:game, game)
    |> assign(:name, name)
    BackupAgent.put(name, game)
    {:ok, %{"join" => name, "game" => Game.user_view(game)}, socket}
  end

  #TODO handle flip messages, fix flipping
  def handle_in("flip", %{"value" => vv}, socket) do
    IO.puts("Flip topic noitfied...")
    #name = socket.assigns[:name]
    game = Game.flip(socket.assigns[:game], vv)
    socket = assign(socket, :game, game)
    #BackupAgent.put(name, game)
    IO.puts("complete.")

    #TODO causing (:ok module undefined)
    {:reply, {:ok, %{ "game" => Game.user_view(game)}}, socket}
  end

	#TODO handle reset messages

end
