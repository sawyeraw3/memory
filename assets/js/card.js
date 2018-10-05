
import React, {Component} from "react";

export default class Card extends Component {
  constructor(props) {
    super(props);
    this.sendFlip = this.sendFlip.bind(this);
  }

//TODO send card value (or just card?) on click, send properly formatted message
  sendFlip(ev) {
    //Client side flip
    /*if (!this.props.flipped) {
      this.props.isPair(this.props.value, this.props.id);
    }*/
    
    //let card = this.props;

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
    //this.props.channel.push("flip", {flipped_card : card})
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
