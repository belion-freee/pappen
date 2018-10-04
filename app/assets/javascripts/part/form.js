$(function () {
  // display check-mark at selected
  $('.selectpicker').selectpicker({
    iconBase: 'fontawesome',
    tickIcon: 'fa fa-check'
  });

  // refresh because it cannot display because of side effect at first
  $('.selectpicker').selectpicker('refresh');

  // select all
  $("#select_all").click(function () {
    $('.selectpicker').selectpicker('selectAll');
  });

  // default close
  $("#panelCollapse").collapse('hide');

  // margin print
  $("i.fa-percent").click(function () {
    var target = $("#expenditure-margin");
    if (target.attr("disabled")) {
      target.removeAttr("disabled");
    } else {
      target.val("");
      target.attr("disabled", "disabled");
    }
  });
});