;(function ($) {
  function $loader() {
    if ($('#loader').length) { return $('#loader'); }

    var $loader = $("<div id='loader'>Loading...</div>");
    $("#top").append($loader);
    return $loader;
  }

  $.loading = {
    start: function () {
      $('body').addClass('loading');
      $loader().show();
    },

    finish: function () {
      $('body').removeClass('loading');
      $loader().fadeOut('fast');
      $('body').show();
      $.unscreen();
    }
  };
})(jQuery);
