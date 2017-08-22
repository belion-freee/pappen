$(function() {
  // make options of departure IC
  $('#select_from_prefectures').change(function() {
    makeOptions('#select_from_prefectures', '#select_from_ic');
  });

  // make options of arrival IC
  $('#select_to_prefectures').change(function() {
    makeOptions('#select_to_prefectures', '#select_to_ic');
  });

  // make ic options by selected prefectures
  const makeOptions = function(psel, csel) {
    $.ajax({
      type: "POST",
      url: "/options",
      data: {
        name: pval = $(psel).find("option:selected").val()
      },
      headers: {
        "X-CSRF-Token": $("meta[name=csrf-token]").attr("content"),
      },
    }).done(function(data) {
      var options = $.map(data, function(val) {
        return `<option value="${val}">${val}</option>`;
      });
      $(csel).empty();
      $(csel).append(options);
    });
  };
});
