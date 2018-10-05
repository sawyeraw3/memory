
import React, {Component} from "react";

export default class Card extends Component {
  constructor(props) {
    super(props);
    this.sendFlip = this.sendFlip.bind(this);
  }

  sendFlip(ev) {


    //Strip card of channel
    let c = [0, {
      value: this.props.value,
      matched: this.props.matched,
      isPair: this.props.isPair,
      flipped: this.props.flipped,
    }];

  //TODO push right data to channel
    console.log(`card to send: ${c}`);
    //Channel gotten from memory App
    this.props.channel.push("flip", {flipped_card : c})
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
