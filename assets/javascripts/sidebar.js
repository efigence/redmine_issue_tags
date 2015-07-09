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
        $('#toggle-private-form').text( $('#toggle-private-form').data('add') );
      }
    });
  });

  $('#toggle-private-form').click(function(e){
    e.preventDefault();
    var form = $('#add-private-form');

    if (form.is(':visible')) {
      $(this).text( $(this).data('add') );
      form.hide();
    } else {
      $(this).text( $(this).data('cancel') );
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
        $('#toggle-public-form').text( $('#toggle-public-form').data('add') );
      }
    });
  });


  $('#toggle-public-form').click(function(e){
    e.preventDefault();
    var form = $('#add-public-form');

    if (form.is(':visible')) {
      $(this).text( $(this).data('add') );
      form.hide();
    } else {
      $(this).text( $(this).data('cancel') );
      form.show();
    }
  });

  $("#tags-wrapper").on("click", "span.tag-del", function(e) {
    e.preventDefault();
    var container = $(this).parent(),
        confirmation = $(this).closest('#tags-wrapper').data('confirm');

    if (confirm(confirmation)) {
      $.ajax({
        type: 'DELETE',
        url: $(this).data('url'),
        success: function(resp) {
          container.remove();
        }
      });
    }
  });

  $('input#private_tag').selectize({
    delimiter: ',',
    // persist: false,


    create: function(input) {
        return {
            // value: input,
            // text: input,
            name: input
        }
    },
    valueField: 'name',
    labelField: 'name',
    searchField: 'name',
    options: [],
    loadThrottle: 600,
    allowEmptyOption: true,
    load: function(query, callback) {
        if (!query.length) return callback();
        $.ajax({
            url: '/tags_api/private',
            type: 'GET',
            dataType: 'json',
            data: {
                name: query
            },
            error: function() {
                callback();
            },
            success: function(res) {
                // you can apply any modification to data before passing it to selectize
                callback(res.tags);
                // res is json response from server
                // it contains array of objects. Each object has two properties. In this case 'id' and 'Name'
                // if array is inside some other property of res like 'response' or something. than use this
                //callback(res.response);
            }
        });
    }
  });

  $('input#public_tag').selectize({
    delimiter: ',',
    persist: false,
    create: function(input) {
        return {
            value: input,
            text: input
        }
    }
  });


  // $('input#private_tag').keypress(function(e) {
  //   if (e.keyCode == 13) {
  //     $('#add_private').click();
  //   }
  // });

  // $('input#public_tag').keypress(function(e) {
  //   if (e.keyCode == 13) {
  //     $('#add_public').click();
  //   }
  // });


});
