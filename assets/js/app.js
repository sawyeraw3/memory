//References in ./lib/memory_web/templates/page/index.html.eex
// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
import css from "../css/app.css";

// webpack automatically bundles all modules in your
// entry points. Those entry points can be configured
// in "webpack.config.js".
//
// Import dependencies
//
import $ from "jquery";
import "phoenix_html";
import socket from "./socket"
import game_init from "./game-controller";

function start() {
  let root = document.getElementById('root');
  if (root) {
    let channel = socket.channel("games:" + window.gameName, {});
    // We want to join in the react component.
    game_init(root, channel);
  }
}

$(start);


/*
let channel = socket.channel("games:demo", {});
channel.join()
  .receive("ok", resp => { console.log("Joined successfully", resp) })
  .receive("error", resp => { console.log("Unable to join", resp) });

function form_init() {
  $('#game-button').click(() => {
    let xx = $('#game-input').val();
    console.log("double", xx);
    channel.push("double", { xx: xx }).receive("doubled", msg => {
      console.log("doubled", msg);
      $('#game-output').text(msg.yy);
    });
  });
}

function start() {
  let root = document.getElementById('root');
  if (root) {
    game_init(root);
  }

  if (document.getElementById('game-input')) {
    form_init();
  }
}

$(start);
*/

/*
$(() => {
  let root = $('#root')[0];
  game_init(root);
});
*/
