function showPopUp() {
  $('.flash-popup').fadeIn(500).delay(2500).fadeOut(1000);
};

function attachSubmit() {
  $('.submit').on('click', function(e) {
    e.preventDefault();
    $('.form')[0].submit()
  });
}
