$(function() {
  var navOffset = $('#nav-left').offset().top;
  $(window).scroll(function() {
    if ($(this).scrollTop() > navOffset) {
      $('#nav-left').css({
        'position': 'fixed',
        'margin-top': '-140px'
      });
    }
    else if ($(this).scrollTop() < navOffset) {
      $('#nav-left').css({
        'position': 'absolute',
        'margin-top': '0'
      });

    }
  });
});
