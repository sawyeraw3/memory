defmodule Memory.Game do

  def new do
    initializeTiles = Enum.shuffle([
        %{letter: "A", index: 0, tileStatus: "notFlipped"},
        %{letter: "A", index: 1, tileStatus: "notFlipped"},
        %{letter: "B", index: 2, tileStatus: "notFlipped"},
        %{letter: "B", index: 3, tileStatus: "notFlipped"},
        %{letter: "C", index: 4, tileStatus: "notFlipped"},
        %{letter: "C", index: 5, tileStatus: "notFlipped"},
        %{letter: "D", index: 6, tileStatus: "notFlipped"},
        %{letter: "D", index: 7, tileStatus: "notFlipped"},
        %{letter: "E", index: 8, tileStatus: "notFlipped"},
        %{letter: "E", index: 9, tileStatus: "notFlipped"},
        %{letter: "F", index: 10, tileStatus: "notFlipped"},
        %{letter: "F", index: 11, tileStatus: "notFlipped"},
        %{letter: "G", index: 12, tileStatus: "notFlipped"},
        %{letter: "G", index: 13, tileStatus: "notFlipped"},
        %{letter: "H", index: 14, tileStatus: "notFlipped"},
        %{letter: "H", index: 15, tileStatus: "notFlipped"},
     ])
   %{
     tiles: initializeTiles,
     clicks: 0,
     numOfmatch: 0,
     card1: nil,
     card2: nil,
     timeout: false,
     players: %{},
     curPlayer: nil,
     observers: %{},
   }
  end

  def checkTimeout(game) do
    c1 = game.card1
    c2 = game.card2
    if c1 != nil && c2 != nil do
      true
      IO.puts("true, in timeout")
    else
      false
    end
  end


  #Called after game created or found, adds users to game
  def new(game, user) do
    IO.puts("in new/2")
    if(map_size(game.players) != 2) do
      players = game.players
      #players = Enum.map players, fn {user, info} ->
      #  {user, %{ default_player() | score: info.score || 0 }}
      #end
      
      #generate one of 2 new players
      newP = %{name: user, score: 0, clicks: 0}
      game = Map.put(game, :curPlayer, user)
      
      #game = Map.put(game, :players, Enum.into(players, %{}))
      
      #if we have a user1, add a user2
      if(map_size(players) == 1) do
        players = Map.put(players, :user1, newP)
      else
        players = Map.put(players, :user2, newP)
      end

      game = Map.put(game, :players, players)
    else
      #if 2 players playing, add new visitors as observers
      observers = game.observers
      observers = Enum.map observers, fn {user} ->
        %{observer: user}
      end
      game = Map.put(game, :observers, Enum.into(observers, %{}))
    end
  end

  #def default_player() do
  #    %{
  #      score: 0,
  #      clicks: 0,
  #      cooldown: nil,
  #    }
  #end


  #after player cooldown is up, determine state of touched cards, change turn
  def cooled(game, user) do
    idx1 = Enum.find_index(game.tiles, fn(x)-> x.index == game.card1.index end)
    idx2 = Enum.find_index(game.tiles, fn(x)-> x.index == game.card2.index end)
    #determine if match
    newtiles = game.tiles
    
    #TODO switch players here
    # if(game.curPlayer == Enum.at(game.players, 0).name) do
    #   game == Map.put(game, :curPlayer, Enum.at(game.players, 0).name)
    # else
    #   game == Map.put(game, :curPlayer, Enum.at(game.players, 1).name)
    # end

    if game.card1.letter == game.card2.letter do
      IO.puts("COOLED: match found")
      newtiles = List.replace_at(game.tiles, idx1,
      %{
        letter: Enum.at(game.tiles, idx1).letter,
        index: Enum.at(game.tiles, idx1).index,
        tileStatus: "checked",#"checked",
      }
      )
      |>List.replace_at(idx2,
      %{
        letter: Enum.at(game.tiles, idx2).letter,
        index: Enum.at(game.tiles, idx2).index,
        tileStatus: "checked",#"checked",
      })
      %{
        clicks: game.clicks,
        tiles: newtiles,
        numOfmatch: game.numOfmatch,
        card1: nil,
        card2: nil,
        players: game.players,
        timeout: false,
        curPlayer: nil,
        observers: %{},
        #cooldown: get_cd(game, user),
      }
    else
      IO.puts("COOLED: no match")
      newtiles = List.replace_at(game.tiles, idx1,
      %{
        letter: Enum.at(game.tiles, idx1).letter,
        index: Enum.at(game.tiles, idx1).index,
        tileStatus: "notFlipped",
      }
      )
      |>List.replace_at(idx2,
      %{
        letter: Enum.at(game.tiles, idx2).letter,
        index: Enum.at(game.tiles, idx2).index,
        tileStatus: "notFlipped",
      })
      %{
        clicks: game.clicks,
        tiles: newtiles,
        numOfmatch: game.numOfmatch,
        card1: nil,
        card2: nil,
        players: game.players,
        timeout: false,
        curPlayer: nil,
        observers: %{},
        #cooldown: get_cd(game, user),
      }
    end
  end

  def get_cd(game, user) do
      done = (get_in(game.players, [user, :cooldown]) || 0)
      left = done - :os.system_time(:milli_seconds)
      max(left, 0)
  end


  #TODO if called by !curPlayer, return unchanged view
    def client_view(game, user) do     
      IO.inspect(game.curPlayer)
      #if(map_size(game.players) == 2) do
      # if(user == game.curPlayer && map_size(game.players) == 2) do
        if(game.timeout) do
          game = Map.put(game, :timeout, false)
        end
        g = matchOrNot(game, user)
        if(g) do
          g = Map.put(game, :timeout, g.timeout)
       
          ps = Enum.map g.players, fn {pn, pi} ->
          %{ name: pn, guesses: Enum.into(pi.guesses, []), score: pi.score } end
      
          %{
            clicks: g.clicks,
            tiles: g.tiles,
            numOfmatch: g.numOfmatch,
            card1: g.card1,
            card2: g.card2,
            players: ps,
            timeout: g.timeout,
            #cooldown: get_cd(g, user),
          }
        else
          ps = Enum.map game.players, fn {pn, pi} ->
            %{ name: pn, guesses: Enum.into(pi.guesses, []), score: pi.score } end
          %{
            clicks: game.clicks,
            tiles: game.tiles,
            numOfmatch: game.numOfmatch,
            card1: game.card1,
            card2: game.card2,
            players: ps,
            timeout: game.timeout,
            #cooldown: get_cd(game, user),
        }
        end
      #else
      #  game
      #end
    end

  #TODO change users score if match
  def matchOrNot(game, user) do
    match = game.numOfmatch + 1
    if(game.card1 != nil && game.card2 != nil) do
      #Map.put(game, :timeout, false)
      idx1 = Enum.find_index(game.tiles, fn(x)-> x.index == game.card1.index end)
      idx2 = Enum.find_index(game.tiles, fn(x)-> x.index == game.card2.index end)
      if game.card1.tileStatus == "flipped" && game.card2.tileStatus == "flipped" do
        if game.card1.letter == game.card2.letter do
          IO.puts("Match found")
          newtiles = List.replace_at(game.tiles, idx1,
            %{
            letter: Enum.at(game.tiles, idx1).letter,
            index: Enum.at(game.tiles, idx1).index,
            tileStatus: "flipped",#"checked",
            }
          )
          |>List.replace_at(idx2,
          %{
            letter: Enum.at(game.tiles, idx2).letter,
            index: Enum.at(game.tiles, idx2).index,
            tileStatus: "flipped",#"checked",
          })

          %{
            tiles: newtiles,
            clicks: game.clicks,
            numOfmatch: match,
            card1: nil,
            card2: nil,
            timeout: true,
          }
        else
          IO.puts("No match")
          # newtiles = List.replace_at(game.tiles, idx1,
          #   %{
          #     letter: Enum.at(game.tiles, idx1).letter,
          #     index: Enum.at(game.tiles, idx1).index,
          #     tileStatus: "notFlipped",
          #   }
          # )
          # |>List.replace_at(idx2,
          # %{
          #   letter: Enum.at(game.tiles, idx2).letter,
          #   index: Enum.at(game.tiles, idx2).index,
          #   tileStatus: "notFlipped",
          # })

          %{
            tiles: game.tiles, #newtiles,
            clicks: game.clicks,
            numOfmatch: game.numOfmatch,
            card1: nil,
            card2: nil,
            timeout: true,
          }
        end
      else
        game
      end
    end
  end


  def convert_to_atom(params) do
    for {key, val} <- params, into: %{}, do: {String.to_atom(key), val}
  end

  def replaceTiles(game, user, tile) do

    #if we have no current player
    #if(game.curPlayer == nil) do
    #  game = Map.put(game, :curPlayer, user)
    #end
    IO.inspect(game.curPlayer)
    if(user == game.curPlayer) do
      IO.inspect(game.curPlayer)

      firstTile = convert_to_atom(tile)

      if firstTile.tileStatus != "checked" && !(game.card1 != nil && game.card2 != nil) do
        secondTile = Map.put(firstTile, :tileStatus, "flipped")
        trackclick = game.clicks + 1
        if game.card1 == nil do
          idx1 = Enum.find_index(game.tiles, fn(x)-> x.index == secondTile.index end)
          newtiles = List.replace_at(game.tiles, idx1,
          %{
            letter: Enum.at(game.tiles, idx1).letter,
            index: Enum.at(game.tiles, idx1).index,
            tileStatus: "flipped",
            })
          Map.put(game, :tiles, newtiles)
          |> Map.put(:clicks, trackclick)
          |> Map.put(:card1, secondTile)

        else
          if firstTile.index != game.card1.index do
            idx2 = Enum.find_index(game.tiles, fn(x)-> x.index == secondTile.index end)
            newtiles = List.replace_at(game.tiles, idx2,
            %{
              letter: Enum.at(game.tiles, idx2).letter,
              index: Enum.at(game.tiles, idx2).index,
              tileStatus: "flipped",
            })
            Map.put(game, :tiles, newtiles)
            |> Map.put(:clicks, trackclick)
            |> Map.put(:card2, secondTile)
          else
            game
          end
        end
      else
        game
      end
    else
      game
    end
  end


end