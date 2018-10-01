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
import "phoenix_html";
import socket from "./socket"
import $ from "jquery";
import game_init from "./starter-game";

$(() => {
  let root = $('#root')[0];
  game_init(root);
});
