import React, {Component} from "react";

export default class Card extends Component {
  constructor(props) {
    super(props);
    this.handleClick = this.handleClick.bind(this);
  }

  handleClick(e) {
    if (!this.props.flipped) {
      this.props.isPair(this.props.value, this.props.id);
    }
  }

  render() {
    let cardValue = this.props.flipped ? this.props.value : "";
    return (
      <div className={`Card ${this.props.flipped ? "Card--flipped" : ""} ${this.props.matched ? "Card--matched" : ""}`} onClick={this.handleClick}>
        {cardValue}
      </div>
    );
  }
}
