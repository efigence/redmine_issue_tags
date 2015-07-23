(function(){

  var tagsSidebar = {

    init: function() {
      this.events.bindAll();
      this.selectizePrivateForm();
      this.selectizePublicForm();
    },

    events: {

      bindAll: function() {
        this.privateSubmit();
        this.publicSubmit();
        this.togglePrivate();
        this.togglePublic();
        this.tagDelete();
      },

      helpers: {

        submitHelper: function(type) {
          $('#add_' + type).click(function(e){
            e.preventDefault();
            $.ajax({
              type: 'POST',
              url: $(this).data('url'),
              data: {
                issue_id: $(this).data('issue-id'),
                value: $('input#' + type + '_tag').val()
              },
              success: function(resp) {
                if (resp.status === 'success') {
                  var arr = $.map(resp.tag_links, function(v) { return v });
                  $('#' + type + '-tags-container').html( arr.join(''));
                }
              },
              complete: function() {
                $('#add-' + type + '-form').hide();
                $('input#' + type + '_tag').val('');
                $('#toggle-' + type + '-form').text( $('#toggle-' + type + '-form').data('add') );
              }
            });
          });
        },

        toggleHelper: function(type) {
          $('#toggle-' + type + '-form').click(function(e){
            e.preventDefault();
            var form = $('#add-' + type + '-form');
            if (form.is(':visible')) {
              $(this).text( $(this).data('add') );
              form.hide();
            } else {
              $(this).text( $(this).data('cancel') );
              form.show();
            }
          });
        },

        selectizeHelper: function(caller) {
          var addBtn =  caller.next('input[type="submit"]'),
              apiUrl = addBtn.data('api-url');

          var clearOpts = function(selektize) {
            $.each(selektize.options, function(k,v) {
              if ( selektize.items.indexOf(k) === -1 ) {
                selektize.removeOption(k);
              }
            });
            selektize.refreshOptions();
          }

          var opts =  {
            delimiter: ',',
            plugins: ['enter_key_submit'],
            valueField: 'name',
            labelField: 'name',
            searchField: 'name',
            options: [],
            loadThrottle: 600,
            allowEmptyOption: true,

            onInitialize: function () {
              this.on('submit', function () {
                addBtn.click();
                this.clearOptions();
              }, this)
            },

            create: function(input) {
              return { name: input }
            },

            onItemAdd: function() {
              clearOpts(this);
            },

            onBlur: function() {
              clearOpts(this);
            },

            load: function(query, callback) {

              if (!query.length) return callback();
              $.ajax({
                url: apiUrl,
                type: 'GET',
                dataType: 'json',
                data: { name: query },
                error: function() {
                  callback();
                },
                success: function(res) {
                  callback(res.tags);
                }
              });
            }
          }
          return opts;
        }
      },

      privateSubmit: function() {
        this.helpers.submitHelper('private');
      },

      publicSubmit: function() {
        this.helpers.submitHelper('public');
      },

      togglePrivate: function() {
        this.helpers.toggleHelper('private');
      },

      togglePublic: function() {
        this.helpers.toggleHelper('public');
      },

      tagDelete: function() {
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
      }
    },

    selectizePrivateForm: function() {
      this.selectizeForm( $('input#private_tag') );
    },

    selectizePublicForm: function() {
      this.selectizeForm( $('input#public_tag') );
    },

    selectizeForm: function(context) {
      var opts = this.events.helpers.selectizeHelper(context);
      context.selectize(opts);
    }
  }

  $(function(){
    var selectizeEnterPlugin = (function(){
      Selectize.define('enter_key_submit', function (options) {
        var self = this;

        this.onKeyDown = (function (e) {
          var original = self.onKeyDown
          return function (e) {
            if (e.keyCode === 13 && this.$control_input.val() === '') {
              self.trigger('submit')
              e.preventDefault()
              return
            }
            return original.apply(this, arguments)
          }
        })()
      })
    })();
    tagsSidebar.init();
  });
})();
