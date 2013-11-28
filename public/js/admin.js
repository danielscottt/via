$(function() {

  $('.edit').on('click', function() {
    var permalink = $(this).closest('tr').attr('link');
    window.location.href = '/admin/post/'+permalink;
  });
  
  $('.view').on('click', function() {
    var permalink = '/' + $(this).closest('tr').attr('link');
    window.location.href = permalink;
  });

  $('.delete').on('click', function() {
    var permalink = '/' + $(this).closest('tr').attr('link');
    $.get('/admin'+permalink+'/delete/confirm', function(data) {
      $('#post-data').css('text-align', 'left');
      $('#post-data').html(data);
    });
    $('#delete-modal').modal();
  }); 

  $('#delete-post-btn').on('click', function() {
    var postId = $('#del-title').attr('post_id');
    $.post('admin/post/'+postId+'/delete', function() {
      window.location.href = '/admin';
    });
  });

  $("form#post-form").submit(function(event) {
    event.preventDefault();
  });
  
  $('.post-btn').on('click', function() {
    var _this = this;
    $.ajax({
      type: "POST",
      url: "/admin/post",
      data: $('#post-form').serialize(),
      success: function(resp) {
        json = JSON.parse(resp);
        $('#id').val(json.response.post.id);
        var json = JSON.parse(resp);
        if ($(_this).attr('reload') == 'true') {
          window.location.href = '/admin';
        }
        else if ($(_this).attr('preview') == 'true') {
          window.location.href = '/'+json.response.post.permalink
        }
      }
    });
  });

  $('#post-btn-cancel').on('click', function() {
    var conf = window.confirm("Are you sure you want to leave this page without saving?");
    if (conf) {
      window.location.href = '/admin';
    }
  });

  $('#publisher').on('click', function() {
    if ($(this).hasClass('fa-check-square-o')) {
      $('#publish').prop('checked', false);
      $(this).removeClass('fa-check-square-o');
      $(this).addClass('fa-square-o');
    }
    else if ($(this).hasClass('fa-square-o')) {
      $('#publish').prop('checked', true);
      $(this).removeClass('fa-square-o');
      $(this).addClass('fa-check-square-o');
    } 
  });
    
});
