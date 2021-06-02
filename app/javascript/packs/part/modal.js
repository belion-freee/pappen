$(() => {
    const swal = require('sweetalert2');

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

    // edit event
    $("#edit-event").on("click", (e) => {
      e.preventDefault();
      e.stopPropagation();

      // store form HTML markup in a JS variable
      let form = $('#event-form > form');

      // input form
      form.find("#event_name").val(e.currentTarget.innerText)
      form.find("#event_memo").val($("#event-memo p").text())

      let body = (form) => {
        return {
          event: {
           name: form.find("#event_name").val(),
           room_member_ids: form.find("#event_room_members").val(),
           memo: form.find("#event_memo").val(),
          }
        }
      }

      swalFrom(e.currentTarget.dataset, form, body);
    });

    // new house expenditure
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

    // new event expense
    $("#new-expense").on("click", (e) => {
      e.preventDefault();
      e.stopPropagation();

      let body = (form) => {
        let exempt_member_ids = []
        form.find("#expense_exempts option:selected").each(function(i, r) {
          exempt_member_ids.push(r.value);
        })
        return {
          expense: {
           event_id:   form.find("#event_id").val(),
           room_member_id: form.find("#expense_room_member option:selected").val(),
           name: form.find("#expense_name option:selected").val(),
           payment: form.find("#expense_payment").val(),
           memo: form.find("#expense_memo").val(),
           exempt_ids: exempt_member_ids,
          }
        }
      }

      swalFrom(e.currentTarget.dataset, $('#expense-form > form'), body);
    });

    // new expenditure
    $("#new-expenditure").on("click", (e) => {
      e.preventDefault();
      e.stopPropagation();

      let body = (form) => {
        return {
          expenditure: {
           line_user_id:   form.find("#line_user_id").val(),
           entry_date: form.find("#expenditure_entry_date").val(),
           category: form.find("#expenditure_category option:selected").val(),
           payment: form.find("#expenditure_payment").val(),
           margin: form.find("#expenditure_margin").val(),
           memo: form.find("#expenditure_memo").val(),
          }
        }
      }

      swalFrom(e.currentTarget.dataset, $('#expenditure-form > form'), body);
    });

    // edit house expenditure
    var touchInterval = null;
    var touchTime     = 0;
    var isTouch       = false;
    $(".edit-house-expenditure").on({
      "touchstart": (e) => {
        // clear timer
        touchTime = 0;
        isTouch = true;
        touchInterval = setInterval(() => {
          touchTime += 100;
          if (touchTime > 1000) {
            clearInterval(touchInterval);
          }
        }, 100)
      },
      "touchmove": (e) => {
        isTouch = false;
      },
      "touchend": (e) => {
        if (isTouch) {
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
      }
    });

    $(".edit-expense").on({
      "touchstart": (e) => {
        // clear timer
        touchTime = 0;
        isTouch = true;
        touchInterval = setInterval(() => {
          touchTime += 100;
          if (touchTime > 1000) {
            clearInterval(touchInterval);
          }
        }, 100)
      },
      "touchmove": (e) => {
        isTouch = false;
      },
      "touchend": (e) => {
        if (isTouch) {
          e.preventDefault();
          e.stopPropagation();

          if (touchTime < 700) {
            const target = e.currentTarget

            // store form HTML markup in a JS variable
            let form = $('#expense-form > form');

            // input form
            form.find("#expense_room_member option[value=" + target.querySelector("td[name=room_member]").getAttribute("value") + "]").attr("selected", "selected")
            form.find("#expense_name option[value=" + target.querySelector("td[name=name]").innerText + "]").attr("selected", "selected")
            form.find("#expense_payment").val(target.querySelector("td[name=payment]").getAttribute("value"))
            form.find("#expense_memo").val(target.querySelector("td[name=memo] p").textContent)
            exempt_member_ids = target.querySelector("td[name=exempt_members]").getAttribute("value")
            if (exempt_member_ids) {
              $.each(exempt_member_ids.split(","), function(i, r) {
                form.find("#expense_exempts option[value=" + r + "]").attr("selected", "selected")
              })
            }

            let body = (form) => {
              let exempt_member_ids = []
              form.find("#expense_exempts option:selected").each(function(i, r) {
                exempt_member_ids.push(r.value);
              })
              return {
                expense: {
                 event_id:   form.find("#event_id").val(),
                 room_member_id: form.find("#expense_room_member option:selected").val(),
                 name: form.find("#expense_name option:selected").val(),
                 payment: form.find("#expense_payment").val(),
                 memo: form.find("#expense_memo").val(),
                 exempt_ids: exempt_member_ids,
                }
              }
            }

            swalFrom(target.dataset, form, body);
          } else {
            swalDelete(e.currentTarget.dataset)
          }
        }
      }
    });

    $(".edit-expenditure").on({
      "touchstart": (e) => {
        // clear timer
        touchTime = 0;
        isTouch = true;
        touchInterval = setInterval(() => {
          touchTime += 100;
          if (touchTime > 1000) {
            clearInterval(touchInterval);
          }
        }, 100)
      },
      "touchmove": (e) => {
        isTouch = false;
      },
      "touchend": (e) => {
        if (isTouch) {
          e.preventDefault();
          e.stopPropagation();
          if (touchTime < 700) {
            const target = e.currentTarget

            // store form HTML markup in a JS variable
            let form = $('#expenditure-form > form');

            // input form
            form.find("#expenditure_category option[value=" + target.querySelector("td[name=category]").innerText + "]").attr("selected", "selected")
            form.find("#expenditure_entry_date").val(target.querySelector("td[name=entry_date]").attributes.value.value)
            form.find("#expenditure_payment").val(target.querySelector("td[name=payment]").getAttribute("value"))
            form.find("#expenditure_memo").val(target.querySelector("td[name=memo] p").textContent)

            let body = (form) => {
              return {
                expenditure: {
                 line_user_id:   form.find("#line_user_id").val(),
                 entry_date: form.find("#expenditure_entry_date").val(),
                 category: form.find("#expenditure_category option:selected").val(),
                 payment: form.find("#expenditure_payment").val(),
                 margin: form.find("#expenditure_margin").val(),
                 memo: form.find("#expenditure_memo").val(),
                }
              }
            }

            swalFrom(target.dataset, form, body);
          } else {
            swalDelete(e.currentTarget.dataset)
          }
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
            swal(
              { type: 'success', title: '削除したよ!'}
            ).then(() => {
              location.reload();
            });
          });
        }
      }, (dismiss) => {})
    }
});
