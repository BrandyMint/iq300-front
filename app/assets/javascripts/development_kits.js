//= require ./lib/retina-testing/scale.fix.js
//= require ./lib/retina-testing/detect-zoom.js

$(document).ready(function () {
  var checkPixelRatio = function() {
    if (window.detectZoom.zoom() > 2) {
      $(document.body).addClass('retina-display');
    } else {
      $(document.body).removeClass('retina-display');
    }
  };

  checkPixelRatio();
  $(window).on('resize', checkPixelRatio);
});