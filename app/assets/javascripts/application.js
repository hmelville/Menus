//= require ./pStrength.jquery
//= require foundation
//= require jquery-ui/datepicker

$(function(){
  $(document).foundation();
  showPopUp();

  $('.datepickable').each(function(){
    $(this).prop("autocomplete", 'off');
  });
});

function showPopUp() {
  $('.flash-popup').fadeIn(500).delay(2500).fadeOut(1000);
};

