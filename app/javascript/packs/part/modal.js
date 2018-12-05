$(() => {
    const swal = require('sweetalert2');

    // tweet
    $("#tweet-maxim").on("click", (e) => {
      e.preventDefault();
      e.stopPropagation();

      const data = e.currentTarget.dataset
      const category = JSON.parse(data.category)
      const url = data.url + ".json"

      swal({
        title: 'Choose Category!',
        input: 'select',
        inputOptions: category,
        showCancelButton: true,
        confirmButtonText: 'Tweet',
        showLoaderOnConfirm: true,
        imageUrl: "http://sed.aaschool.ac.uk/wp-content/uploads/2014/05/twitter.png",
        imageWidth: 100,
        imageHeight: 100,
        preConfirm: (data) => {
          return fetch(url, {
            method: 'POST',
            headers: {
              'content-type': 'application/json'
            },
            body: JSON.stringify({category: data})
          }).then(response => {
            if (response.ok) {
              return response.json()
            } else {
              swal.showValidationMessage(`Ooops...Failed<br>Try another one`)
            }
          })
        },
        allowOutsideClick: () => !swal.isLoading()
      }).then((result) => {
        if (result.value) {
          swal({type: 'success', title: 'Tweeted', text: 'Tweet Success!', footer: '<a href="https://twitter.com/meigensanBot" target="_blank">Go to Twitter</a>'})
        }
      })
    });

    $("#new-maxims").on('click', (e) => {
      e.preventDefault();
      e.stopPropagation();

      // body
      let body = (form) => {
        return {
          maxim: {
            category: form.find("#maxim_category option:selected").val(),
            remark: form.find("#maxim_remark").val(),
            author: form.find("#maxim_author").val(),
            source: form.find("#maxim_source").val(),
            url: form.find("#maxim_url").val()
          }
        }
      }

      const resOpts = {footer: '<a href="' + $("#new-maxims").data("url") + '">Show All Remarks</a>'}

      swalFrom(e.currentTarget.dataset, $('#form-template > form'), body, resOpts);
    });

    $(".edit-maxim").on("click", (e) => {
      e.preventDefault();
      e.stopPropagation();

      const target = e.currentTarget

      // body
      let body = (form) => {
        return {
          maxim: {
            category: form.find("#maxim_category option:selected").val(),
            remark: form.find("#maxim_remark").val(),
            author: form.find("#maxim_author").val(),
            source: form.find("#maxim_source").val(),
            url: form.find("#maxim_url").val()
          }
        }
      }

      // input form
      let form = $('#form-template > form');
      form.find("#maxim_category option[value=" + target.querySelector("td[name=category]").textContent + "]").attr("selected", "selected")
      form.find("#maxim_remark").val(target.querySelector("td[name=remark] p").textContent)
      form.find("#maxim_author").val(target.querySelector("td[name=author]").textContent)
      form.find("#maxim_source").val(target.querySelector("td[name=source]").textContent)
      form.find("#maxim_url").val(target.querySelector("td[name=url]").textContent)

      swalFrom(target.dataset, form, body);
    });

    // edit house
    $("#edit-house").on("click", (e) => {
      e.preventDefault();
      e.stopPropagation();

      // store form HTML markup in a JS variable
      let form = $('#house-form > form');

      // input form
      form.find("#house_name").val(e.currentTarget.innerText)
      form.find("#house_memo").val($("#house-memo p").text())

      let body = (form) => {
        return {
          house: {
           name: form.find("#house_name").val(),
           room_member_ids: form.find("#house_room_members").val(),
           memo: form.find("#house_memo").val(),
          }
        }
      }

      swalFrom(e.currentTarget.dataset, form, body);
    });

    // new expenditure
    $("#new-house-expenditure").on("click", (e) => {
      e.preventDefault();
      e.stopPropagation();

      let body = (form) => {
        return {
          house_expenditure: {
           house_id:   form.find("#house_id").val(),
           room_member_id: form.find("#house_expenditure_room_member option:selected").val(),
           entry_date: form.find("#house_expenditure_entry_date").val(),
           category: form.find("#house_expenditure_category option:selected").val(),
           payment: form.find("#house_expenditure_payment").val(),
           name: form.find("#house_expenditure_name").val(),
           house_expenditure_margins_attributes: $.map(form.find("#house_expenditure_margins .form-group"), (hem, _) => {
             const margin = hem.querySelector("#house_expenditure_room_members_margin").value
             const fixed  = hem.querySelector("#house_expenditure_room_members_fixed").value
             if ((margin == "") && (fixed == "")) { return null }
             return {
               room_member_id: hem.querySelector("label[for=house_expenditure_room_members_room_member]").dataset.member,
               margin: margin,
               fixed: fixed
             }
           }),
          }
        }
      }

      swalFrom(e.currentTarget.dataset, $('#house-expenditure-form > form'), body);
    });

    // edit house expenditure
    var touchInterval = null;
    var touchTime     = 0;
    $(".edit-house-expenditure").on({
      "touchstart mousedown": (e) => {
        e.preventDefault();
        e.stopPropagation();

        // clear timer
        touchTime = 0;
        touchInterval = setInterval(() => {
          touchTime += 100;
          if (touchTime > 1000) {
            clearInterval(touchInterval);
          }
        }, 100)
      },
      "touchend mouseup": (e) => {
        e.preventDefault();
        e.stopPropagation();
        if (touchTime < 700) {
          const target = e.currentTarget

          // store form HTML markup in a JS variable
          let form = $('#house-expenditure-form > form');

          // input form
          form.find("#house_expenditure_room_member option[value=" + target.querySelector("td[name=room_member]").attributes.value.value + "]").attr("selected", "selected")
          form.find("#house_expenditure_category option[value=" + target.dataset.category + "]").attr("selected", "selected")
          form.find("#house_expenditure_entry_date").val(target.querySelector("td[name=entry_date]").attributes.value.value)
          form.find("#house_expenditure_payment").val(target.querySelector("td[name=payment]").attributes.value.value)
          form.find("#house_expenditure_name").val(target.querySelector("td[name=name]").textContent)

          // input margins
          const margins = JSON.parse(target.dataset.margins)
          if (margins.length) {
            $.each(margins, (_, margin) => {
              let marginForm = form.find(`#margin_member_${margin.room_member_id}`)
              marginForm.find("label[for=house_expenditure_room_members_room_member]")[0].dataset.id = margin.id
              marginForm.find("#house_expenditure_room_members_margin").val(margin.margin)
              marginForm.find("#house_expenditure_room_members_fixed").val(margin.fixed)
            });
          }

          let body = (form) => {
            return {
              house_expenditure: {
               house_id:   form.find("#house_id").val(),
               room_member_id: form.find("#house_expenditure_room_member option:selected").val(),
               entry_date: form.find("#house_expenditure_entry_date").val(),
               category: form.find("#house_expenditure_category option:selected").val(),
               payment: form.find("#house_expenditure_payment").val(),
               name: form.find("#house_expenditure_name").val(),
               house_expenditure_margins_attributes: $.map(form.find("#house_expenditure_margins .form-group"), (hem, _) => {
                 const margin = hem.querySelector("#house_expenditure_room_members_margin").value
                 const fixed  = hem.querySelector("#house_expenditure_room_members_fixed").value
                 if ((margin == "") && (fixed == "")) { return null }
                 const data = hem.querySelector("label[for=house_expenditure_room_members_room_member]").dataset
                 return {
                   id: data.id,
                   room_member_id: data.member,
                   margin: margin,
                   fixed: fixed
                 }
               }),
              }
            }
          }

          swalFrom(target.dataset, form, body);
        } else {
          swalDelete(e.currentTarget.dataset)
        }
      }
    });

    function swalFrom(data, form, body, resOpts = {}) {
      swal({
        type: 'info',
        title: data.title,
        html: form,
        showCancelButton: true,
        confirmButtonText: 'OK',
        animation: false,
        customClass: 'animated bounceInUp',
        onClose: () => {
          form[0].reset();
          form.find("select option").removeAttr("selected");
        },
        preConfirm: () => {
          return fetch(data.url + ".json", {
            method: data.method,
            headers: {
              'content-type': 'application/json',
            },
            body: JSON.stringify(body($("#swal2-content > form")))
          }).then((response) => {
            if (!response.ok) {
              return response.json().then((json) => {
                throw new Error(json.errors.join("<br>"));
              });
            }
            return response.json()
          }).catch(error => {
            swal.showValidationMessage(error);
          });
        },
        allowOutsideClick: () => !swal.isLoading()
      }).then((result) => {
        if (result.value) {
          // reset form
          form[0].reset();
          swal(Object.assign(
            { type: 'success', title: '完了したよ!'},
            resOpts
          )).then(() => {
            location.reload();
          });
        }
      });
    }

    function swalDelete(data) {
      swal({
        title: "レコード削除",
        text: "本当に削除しますか?",
        type: 'warning',
        showCancelButton: true,
        confirmButtonColor: '#3085d6',
        cancelButtonColor: '#d33',
        confirmButtonText: 'はい',
        cancelButtonText:  'いいえ',
        animation: false,
        customClass: 'animated bounceIn',
      }).then((result) => {
        if (result.value) {
          fetch(data.url + ".json", {
            method: "DELETE",
            headers: {
              'content-type': 'application/json',
            }
          }).then(() => {
            location.reload();
          });
        }
      }, (dismiss) => {})
    }
});
