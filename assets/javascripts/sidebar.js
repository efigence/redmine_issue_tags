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
          var arr = $.map(resp.tag_links, function(v){
            return v
          });
          $('#private-tags-container').html( arr.join(''));
        }
      },
      complete: function() {
        $('#add-private-form').hide();
        $('input#private_tag').val('');
        $('#toggle-private-form').text('Add');
      }
    });
  });

  $('#toggle-private-form').click(function(e){
    e.preventDefault();
    var form = $('#add-private-form');

    if (form.is(':visible')) {
      $(this).text('Add');
      form.hide();
    } else {
      $(this).text('Cancel');
      form.show();
    }
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
          var arr = $.map(resp.tag_links, function(v){
            return v
          });
          $('#public-tags-container').html( arr.join(''));
        }
      },
      complete: function() {
        $('#add-public-form').hide();
        $('input#public_tag').val('');
        $('#toggle-public-form').text('Add');
      }
    });
  });


  $('#toggle-public-form').click(function(e){
    e.preventDefault();
    var form = $('#add-public-form');

    if (form.is(':visible')) {
      $(this).text('Add');
      form.hide();
    } else {
      $(this).text('Cancel');
      form.show();
    }
  });

  $("#tags-wrapper").on("click", "span.tag-del", function(e) {
    e.preventDefault();
    var self = $(e.target),
        container = self.parent();

    if (confirm('Are you sure to detach this tag from issue?')) {
      $.ajax({
        type: 'DELETE',
        url: self.data('url'),
        success: function(resp) {
          container.remove();
        }
      });
    }
  });
});
