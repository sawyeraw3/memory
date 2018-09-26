import React, {Component} from "react";
import Card from "./card.js";

function getNewCards() {
  const cardDict = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H'];
  let cards = [];
  for(let i=0; i<2; i++) {
    let cardDictCopy = cardDict.slice(0);
    for(let y=0; y<8; y++) {
      let index = Math.floor(Math.random() * cardDictCopy.length);
      cards.push({value: cardDictCopy[index], matched: false, flipped: false})
      cardDictCopy.splice(index, 1);
    }
  }
  return cards;
}

export default class GameController extends Component {
  constructor(vals) {
    super(vals);
    this.createCardRender = this.createCardRender.bind(this);
    this.isPair = this.isPair.bind(this);
    this.resetGame = this.resetGame.bind(this);
    this.createCardElement = this.createCardElement.bind(this);

    this.state = {
      clicks: 0,
      cards: getNewCards(),
      locked: false,
      pairs: 0,
      lastCard: null,
    };
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
          value={card.value}
          isPair={this.isPair}
          flipped={card.flipped} />
        );
  }

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
      cards: getNewCards(),
      locked: false,
      pairs: 0,
      lastCard: null,
    });
  }

  render() {
    let resetButtonText = "New Deal";
    // Game is over if all pairs have been found
    if (this.state.pairs === this.state.cards.length / 2) {
      resetButtonText = `You won in ${this.state.clicks} clicks! Click to play Again`;
    }
    // Render page with cards and reset button
    return (
      <div className="GameController" id="game-controller">
        {this.createCardRender(this.state.cards)}
        <div id="board">
          <button onClick={this.resetGame}>{resetButtonText}</button>
        </div>
      </div>
    );
  }
}