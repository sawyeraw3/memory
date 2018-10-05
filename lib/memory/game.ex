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

  def flip(name, card) do
    Agent.get_and_update __MODULE__, fn lobby -> 
      state = lobby[name]
      clickCount = state[:clicks] + 1
      state = Map.replace state, :clicks, clickCount

      if(!state[:locked]) do        
        [id | card_map] = card
        card_map = Enum.at(card_map, 0)
    
        cards = state[:cards]
        if (!card_map[:flipped]) do
          if (!state[:locked]) do
            card_map = Map.replace card_map, :flipped, true

            #Update state here?
            #state = 
        
            #If last card isn't null, check match
            if (!state[:lastCard]) do
              
              IO.puts("No last Card")
              state = Map.replace state, :lastCard, card
              state = Map.replace state, :locked, false
              {state, Map.replace(lobby, name, state)}
            else
          
              IO.puts("Compare to lastCard")
              [last_id | last_map] = state[:lastCard]
              last_map = Enum.at(last_map, 0)
          
              last_card_compare = %{
                flipped: last_map[:flipped],
                matched: last_map[:matched],
                value: last_map[:value],
              }
          
              IO.puts("last")
              IO.inspect(last_map)

              if(card_map[:value] == last_map[:value]) do
                #card_map = Map.replace card_map, :matched, true
                #last_map = Map.replace last_map, :matched, true
                card_map = Map.replace card_map, :matched, true
                last_map = Map.replace last_map, :matched, true
            
                n_pairs = state[:pairs] + 1

                new_card = [id | card_map]

                before_insert = Enum.take_while(cards, fn(x) -> x != card end)
                before_insert ++ new_card;
                after_insert = Enum.take_while(cards, fn(x) -> !(Enum.member?(before_insert, x)) end)

                cards = before_insert ++ after_insert
                state = Map.replace state, :cards, cards


                lastC = [last_id | last_map]
                state = Map.replace state, :lastCard, lastC
            
                state = Map.replace state, :pairs, n_pairs
                {state, Map.replace(lobby, name, state)}
              else
                #Timeout and flip back
              end
            end
          end
        end

        #lobby = Map.replace(lobby, name, new_s)
        #lobby
        {state, Map.replace(lobby, name, state)}
      else
        {state, Map.replace(lobby, name, state)}
      end
    end
  end


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
      :lastCard => false,
    }
  end


  defp new_card(letter) do
    %{
      value: letter,
      matched: false,
      isPair: false,
      flipped: false
    }
  end

  defp new_cards() do
    vals = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H']
    vals = Enum.shuffle(vals)
    cards = Enum.map(vals, fn (x) -> new_card(x) end)
  end
end
