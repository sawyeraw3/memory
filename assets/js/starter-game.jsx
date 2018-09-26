import React, {Component} from "react";
import ReactDOM from "react-dom";
import _ from "lodash";
import GameController from "./game-controller.js";


export default function game_init(root) {
  ReactDOM.render(<MatchingGame />, root);
}

class MatchingGame extends Component {
  render() {
    return (
      <div>
        <GameController />
      </div>
    );
  }
}
