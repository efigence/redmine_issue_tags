$(function(){
  $('#sidebar').append( $('#tags-wrapper') );

  $('#add_private').click(function(e){
    e.preventDefault();
    $.ajax({
      type: 'POST',
      url: $(this).data('url'),
      data: {
        issue_id: $(this).data('issue-id'),
        value: $('input#private_tag').val()
      },
      success: function(resp) {
        if (resp.status === 'success') {
          var arr = $.map(resp.tags, function(v){
            return '<a href="#" class="tag">'+v+'</a>'
          });
          $('#private-tags-container').html( arr.join(''));
        }
      },
      complete: function() {
        $('#add-private-form').hide();
      }
    });
  });

  $('#show-private-form').click(function(e){
    e.preventDefault();
    $('#add-private-form').show();
  });

  $('#add_public').click(function(e){
    e.preventDefault();
    $.ajax({
      type: 'POST',
      url: $(this).data('url'),
      data: {
        issue_id: $(this).data('issue-id'),
        value: $('input#public_tag').val()
      },
      success: function(resp) {
        if (resp.status === 'success') {
          var arr = $.map(resp.tags, function(v){
            return '<a href="#" class="tag">'+v+'</a>'
          });
          $('#public-tags-container').html( arr.join(''));
        }
      },
      complete: function() {
        $('#add-public-form').hide();
      }
    });
  });

  $('#show-public-form').click(function(e){
    e.preventDefault();
    $('#add-public-form').show();
  });
});
