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
import tippy from 'tippy.js';

// To reference images, add <%= asset_pack_path 'images/hoge.png' %> to View files
require.context('img', true, /\.(png|jpg|jpeg|svg)$/);

window.$ = window.jQuery = require('jquery');
window.graph = Graph;

$(function () {
  // ツールチップ初期化
  tippy("[data-tippy-content]", {
    allowHTML: true
  });

  // accordion
  $('.accordion').accordion({
    "transitionSpeed": 600
  });

  // edit house
  $("#house_date").on("change", function (e) {
    e.preventDefault();
    e.stopPropagation();

    // store form HTML markup in a JS variable
    var target = e.currentTarget;
    var date = target.options[target.options.selectedIndex].value;

    // link to location
    window.location.href = target.dataset.url + "?date=" + date;
  });

  $("#prefectures_name").on("change", function (e) {
    e.preventDefault();
    e.stopPropagation();

    // store form HTML markup in a JS variable
    var km = $("#running_km")[0].value;
    var gm = $("#gas_mileage")[0].value;
    var prefectures = Number($("#prefectures_name option:selected").val());

    $.ajax('gas', {
      type: 'get',
      data: { prefectures: prefectures, km: km, gm: gm },
      dataType: 'json'
    }).done(function (data) {
      $('#gas_price').text("¥ " + data["cost"]);
    }).fail(function () {
      window.alert('正しい結果を得られませんでした');
    });
  });

  $("#house_bill_done").on("change", function (e) {
    // store form HTML markup in a JS variable
    var checkbox = $(e.currentTarget);
    var checked = checkbox.prop("checked");
    var path = checkbox.data("path");
    var date = $("#house_date").find("option:selected").prop("value");

    $.ajax(path, {
      type: 'post',
      data: { done: checked, date: date },
      dataType: 'json'
    }).done(function (data) {
      if (data.done) {
        window.alert('精算しました。');
      } else {
        window.alert('未精算にしました。');
      }
    }).fail(function () {
      window.alert('処理に失敗しました。');
    });
  });
});
