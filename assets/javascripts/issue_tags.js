if (!String.prototype.includes) {
  String.prototype.includes = function() {'use strict';
    return String.prototype.indexOf.apply(this, arguments) !== -1;
  };
}

$(function(){
  var basepath;
  if( window.location.pathname.includes("redmine") ){
    basepath = "/redmine";
  }
  else{
    basepath = "/";
  }
  $("a[href$='/admin/tags']").not( $('.icon-reload') ).css('background-image',  basepath + '/images/ticket1.png' );
})
