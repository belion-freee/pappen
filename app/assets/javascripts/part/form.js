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

  // default close
  $("#panelCollapse").collapse('hide');

  // margin print
  $("i.fa-percent").click(function() {
   let target = $("#expenditure-margin");
   if (target.attr("disabled")) {
     target.removeAttr("disabled");
   } else {
     target.val("");
     target.attr("disabled", "disabled");
   }
  });

  $("#new-maxims").click(function (e) {
    e.preventDefault();
    e.stopPropagation();

        const category = $(this).data("category")
        const url = $(this).data("url")

        // store form HTML markup in a JS variable
        var formTemplate = $('#form-template > form');

        swal({
          title: 'New Remarks',
          html: formTemplate,
          showCancelButton: true,
          confirmButtonText: 'OK',
          preConfirm: function preConfirm() {
            var form = $("#swal2-content > form");
            var body = {
              category: form.find("#maxim_category option:selected").val(),
              remark: form.find("#maxim_remark").val(),
              author: form.find("#maxim_author").val(),
              source: form.find("#maxim_source").val(),
              url: form.find("#maxim_url").val()
            };
            return fetch(url + ".json", {
              method: 'POST',
              headers: {
                'content-type': 'application/json'
              },
              body: JSON.stringify(body)
            }).then(function (response) {
              if (response.ok) {
                return response.json();
              } else {
                response.json().then(function (json) {
                  swal.showValidationError(json.errors.join("<br>"));
                });
              }
            });
          },
          allowOutsideClick: function allowOutsideClick() {
            return !swal.isLoading();
          }
        }).then(function (result) {
          if (result.value) {
            swal({ type: 'success', title: 'Success!', footer: '<a href="' + url + '">Show All Remarks</a>' });
          }
        });
    });
});
