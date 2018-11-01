//= require ./pStrength.jquery
//= require foundation
//= require jquery-ui/datepicker
//= require lib/confirmWithReveal

var dateFormat = "yy-mm-dd"

$(function(){
  $(document).foundation();
  showPopUp();

  $('.datepickable').each(function(){
    $(this).prop("autocomplete", 'off');
  });

  $(document).confirmWithReveal({
    ok: "Yes",
    cancel: "No",
    ok_class: "button left with-padding larger-font",
    cancel_class: "button cancel secondary larger-font"
  });
});

function showPopUp() {
  $('.flash-popup').fadeIn(500).delay(2500).fadeOut(1000);
};

function call_method (url, id, partial, parent_id) {
  $(document.body).css({'cursor' : 'wait'});
  $.ajax({
    url: url,
    type: 'POST',
    dataType: 'JSON',
    data: { 'partial': partial },
    async: false,
    success: function(response){
      console.log(response)
      console.log(response.id)
      console.log(response.html)

      $('#' + response.id).replaceWith(response.html);

      if (response.expand !== "undefined" && response.expand == true) {
        toggleItemsTable(response.id + '_toggle')
      }

      $(document.body).css({'cursor' : 'default'});
    },
    error: function(xhr, error) {
      console.debug(xhr); console.debug(error);
      $(document.body).css({'cursor' : 'default'});
    }
  });
}

function toggleItemsTable(id) {
  $('#' + id).children().toggleClass('fa-chevron-circle-up').toggleClass('fa-chevron-circle-down')
  $('#' + id + '_items_table').slideToggle(500);
  return false;
}