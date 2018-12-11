/* eslint no-console:0 */
// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.
//
// To reference this file, add <%= javascript_pack_tag 'application' %> to the appropriate
// layout file, like app/views/layouts/application.html.erb
import 'jquery-ujs/src/rails';
import 'bootstrap-sass/assets/javascripts/bootstrap';
import 'bootstrap-select/dist/js/bootstrap-select.min.js';
import 'src/application.scss';
import './part/modal';
import 'jq-accordion/dist/js/jquery.accordion';
import Graph from './part/graph';

// To reference images, add <%= asset_pack_path 'images/hoge.png' %> to View files
require.context('img', true, /\.(png|jpg|jpeg|svg)$/);

window.$ = window.jQuery = require('jquery');
window.graph = Graph;

$(() => {
  // accordion
  $('.accordion').accordion({
    "transitionSpeed": 600
  });

  // edit house
  $("#house_date").on("change", (e) => {
    e.preventDefault();
    e.stopPropagation();

    // store form HTML markup in a JS variable
    const target = e.currentTarget
    let date = target.options[target.options.selectedIndex].value;

    // link to location
    window.location.href = target.dataset.url + "?date=" + date;
  });
});
