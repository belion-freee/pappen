$(() => {
  // make options of departure IC
  $('#select_from_prefectures').change(() => {
    makeOptions('#select_from_prefectures', '#select_from_ic');
  });

  // make options of arrival IC
  $('#select_to_prefectures').change(() => {
    makeOptions('#select_to_prefectures', '#select_to_ic');
  });

  // make options of departure IC
  $('ul.result_tab li').click(() => {
    let index = $('ul.result_tab li').index(this);
    $('.result_body').css('display','none');
    $('.result_table').eq(index).css('display','block');
  });

  // make ic options by selected prefectures
  const makeOptions = (psel, csel) => {
    $.ajax({
      type: "POST",
      url: "/options",
      data: {
        name: pval = $(psel).find("option:selected").val()
      },
      headers: {
        "X-CSRF-Token": $("meta[name=csrf-token]").attr("content"),
      },
    }).done((data) => {
      let options = $.map(data, (val) => {
        return `<option value="${val}">${val}</option>`;
      });
      $(csel).empty();
      $(csel).append(options);
    });
  };
});
