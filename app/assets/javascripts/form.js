$(function(){
  // display check-mark at selected
  $('.selectpicker').selectpicker({
      iconBase: 'fontawesome',
      tickIcon: 'fa fa-check'
    }
  );

  // refresh because it cannot display because of side effect at first
  $('.selectpicker').selectpicker('refresh');

  // select all
  $("#select_all").click(function() {
    $('.selectpicker').selectpicker('selectAll');
  });

  $("i.fa-percent").click(function() {
    let target = $("#expenditure-margin");
    target.attr("disabled") ? target.removeAttr("disabled") : target.attr("disabled", "disabled");
  });
});
