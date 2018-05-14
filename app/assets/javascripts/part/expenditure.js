$(function(){
  $("i.fa-percent").click(function() {
   let target = $("#expenditure-margin");
   target.attr("disabled") ? target.removeAttr("disabled") : target.attr("disabled", "disabled");
  });
});
