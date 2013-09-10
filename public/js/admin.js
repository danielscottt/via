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
      
});
