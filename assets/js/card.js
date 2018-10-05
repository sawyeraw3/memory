
import React, {Component} from "react";

export default class Card extends Component {
  constructor(props) {
    super(props);
    this.sendFlip = this.sendFlip.bind(this);
  }

//TODO send card value (or just card?) on click, send properly formatted message
  sendFlip(ev) {
    //Client side flip
    if (!this.props.flipped) {
      this.props.isPair(this.props.value, this.props.id);
    }

    //TODO move to getting index from array of cards in state
    let index = this.props.value;//`${this.props.value}`;
    //Channel gotten from memory App
    this.props.channel.push("flip", {cardIndex : index})
  }

  render() {
    let cardValue = this.props.flipped ? this.props.value : "";
    return (
      <div className={`Card ${this.props.flipped ? "Card--flipped" : ""} ${this.props.matched ? "Card--matched" : ""}`} onClick={this.sendFlip}>
        {cardValue}
      </div>
    );
  }
}
