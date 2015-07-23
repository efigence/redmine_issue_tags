$(function(){

  $('#issue_private_tags').selectize({
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
      // clearOpts(this);
    },

    onBlur: function() {
      // clearOpts(this);
    },

    load: function(query, callback) {

      if (!query.length) return callback();
      $.ajax({
        url: $('#issue_private_tags').data('api-url'),
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
  });

});
