//sticky footer
$(window).load(function(){
  var docHeight = $(document).height()
  var winHeight = $(window).height()
  if(docHeight > winHeight) {
    $('#footer').css('position', 'relative');
  }    
});

$(window).resize(function(){
  var docHeight = $(document).height()
  var winHeight = $(window).height()
  if(docHeight > winHeight) {
    $('#footer').css('position', 'relative');
  }
  else {
    $('#footer').css('position', 'absolute');
  }    
});

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
