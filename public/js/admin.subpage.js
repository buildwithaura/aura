;(function ($) {
  function confirmChanges() {
    if (!$('body').is('.dirty')) { return true; }
    return confirm("This will discard your changes.");
  }

  $("#subtype_select").live('change', function () {
    // if (!confirmChanges()) { return; }

    $('form')
      .append($("<input type='hidden' name='no_save' value='1'>"))
      .addClass('skip-validation')
      .submit();
  });
})(jQuery);
