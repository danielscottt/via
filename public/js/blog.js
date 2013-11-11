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

  $('#nav-left a').on('mouseover', function() {
    var hoverColor = $('i', this).attr('data-hover-color');
    $('i', this).animate({color: hoverColor}, 200);
  });
  $('#nav-left a').on('mouseout', function() {
    $('i', this).css('color', '#222');
  });

});
