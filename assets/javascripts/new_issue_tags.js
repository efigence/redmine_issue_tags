(function(){
  var issueTags = {

    init: function() {
      this.selectizePublicTags();
      this.selectizePrivateTags();
    },

    selectizePublicTags: function() {
      this.selectizeForm( $('#issue_public_tags') );
    },

    selectizePrivateTags: function() {
      this.selectizeForm( $('#issue_private_tags') );
    },

    selectizeForm: function(context) {
      var opts = this.selectizeOpts(context);
      context.selectize(opts);
    },

    selectizeOpts: function(caller) {

      var apiUrl = caller.data('api-url');

      var clearOpts = function(selektize) {
        $.each(selektize.options, function(k,v) {
          if ( selektize.items.indexOf(k) === -1 ) {
            selektize.removeOption(k);
          }
        });
        selektize.refreshOptions();
      }

      var opts = {
        delimiter: ',',
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
  }

  $(function(){

    issueTags.init();

  });

})();
