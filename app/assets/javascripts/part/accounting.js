$(function(){
  // make options of departure IC
  $("#accountings_table input[name='paid']").change(function(event) {
    $.ajax({
      type: "POST",
      url: "/paid",
      data: {
        event_id:       $(location).attr('pathname').match(/events\/(.*)/)[1],
        room_member_id: event.target.value,
        paid:           event.target.checked,
      },
      headers: {
        "X-CSRF-Token": $("meta[name=csrf-token]").attr("content"),
      },
    });
  });
});
