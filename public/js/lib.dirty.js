;(function ($) {
  var dirty = false;

  $("input, textarea, select").live('change', function () {
    if (dirty) { return; }
    if ($(this).is('.neutral')) { return; }

    dirty = true;
    $('body').addClass('dirty').trigger('dirty');
  });
})(jQuery);
