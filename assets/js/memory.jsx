import React, {Component} from "react";
import Card from "./card.js";
import ReactDOM from "react-dom";
import _ from "lodash";


export default function game_init(root, channel) {
    ReactDOM.render(<App channel={channel} />, root);
}

function getNewCards(chan) {
  const cardDict = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H'];
  let cards = [];
  let cardDictCopy = cardDict.slice(0);
  for(let i=0; i<16; i++) {
    let index = Math.floor(Math.random() * cardDictCopy.length);
    cards.push({value: cardDictCopy[index], matched: false, flipped: false, channel: chan});
    cardDictCopy.splice(index, 1);
  }
  return cards;
}


//TODO Give channel to cards when creating
class App extends Component {
  constructor(vals) {
    super(vals);
    this.createCardRender = this.createCardRender.bind(this);
    this.isPair = this.isPair.bind(this);
    this.resetGame = this.resetGame.bind(this);
    this.createCardElement = this.createCardElement.bind(this);
    this.updateState = this.updateState.bind(this);
    this.channel = vals.channel;

    this.channel.on('state_update', state_update => {
      this.updateState(state_update);
      console.log("New State ", state_update)
    })
    
    this.state = {
      game_id: window.gameName,
      clicks: 0,
      cards: getNewCards(this.channel),
      locked: false,
      pairs: 0,
      lastCard: null,
    };

    this.channel.join()
      .receive("ok", this.gotView.bind(this))
      .receive("error", resp => { console.log("Unable to join", resp) })

  }

  updateState(new_state) {
    
    new_state.cards.forEach((card) => card.channel = this.channel);
    
    this.state = {
      game_id: window.gameName,
      clicks: new_state.clicks,

      //TODO need to create elixir card object, replace reference to cards below
      cards: new_state.cards,

      locked: new_state.locked,
      pairs: new_state.pairs,
      lastCard: new_state.lastCard,
    };
    this.setState(this.state);
  }


//TODO handle incoming view, change state accordingly
  gotView(game_state) {
    console.log("new view", game_state);
    this.updateState(game_state);
  }


//TODO send reset_game noti to server
  restGame(id) {

  }

  isPair(value, id) {
    if (this.state.locked) {
      return;
    }

    let cards = this.state.cards;
    cards[id].flipped = true;
    this.setState({cards, locked: true});

    if(!this.state.lastCard) {
      this.setState({
        lastCard: {id, value},
        locked: false,
      });
    } else {
      if (value == this.state.lastCard.value) {
        let pairs = this.state.pairs;
        cards[id].matched = !cards[id].matched;
        cards[this.state.lastCard.id].matched = !cards[this.state.lastCard.id].matched;
        this.setState({cards, lastCard: null, locked: false, pairs: pairs + 1});
      } else {
        setTimeout(() => {
          cards[id].flipped = !cards[id].flipped;
          cards[this.state.lastCard.id].flipped = !cards[this.state.lastCard.id].flipped;
          this.setState({cards, lastCard: null, locked: false});
        }, 500);
      }
    }
    this.state.clicks++;
  }

  createCardElement(card, index) {
    return (
        <Card
          key={index}
          id={index}
          matched={card.matched}
          value={String.fromCharCode(card.value)}
          isPair={this.isPair}
          flipped={card.flipped} 
          channel={card.channel}/>
        );
  }


  //TODO create render from incoming state (parse map)
  // Create all card objects to be rendered on the page
  createCardRender(cards) {
    let index = 0;
    let acc = [];
    for (let i=0; i<4; i++) {
      let c = [];
      for(let y=0; y<4; y++) {
        c.push(this.createCardElement(cards[index], index));
        index++;
      }
      acc.push(<div className="row" id={i}><div className="row" id={index}>{c}</div></div>);
    }
    return acc;
  }

  // Reset the cards on the page
  resetGame() {
    this.setState({
      clicks: 0,
      cards: getNewCards(this.channel),
      locked: false,
      pairs: 0,
      lastCard: null,
    });
  }

  render() {
    let resetButtonText = "New Deal?";
    // Game is over if all pairs have been found
    

    if (this.state.pairs === this.state.cards.length / 2) {
      resetButtonText = `You won in ${this.state.clicks} clicks! Click to play Again`;
    }
    

    // Render page with cards and reset button
    return (
      <div className="GameController" id="game-controller">
        <div className="GameHeader"><h1>React Memory Game!</h1></div>
        
        <div className="ClickCountHeader"><h3>Clicks: {this.state.clicks}</h3></div>
        
        {this.createCardRender(this.state.cards)}
        <div id="board">
          <button onClick={this.resetGame}>{resetButtonText}</button>
        </div>
      </div>
    );
  }
}
