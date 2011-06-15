;(function ($) {
  $('.form-builder fieldset').livequery(function () {
    var $this = $(this);
    $(this).sortable({
      axis: 'y',
      opacity: 0.5
    });

    $('a.delete', $this).live('click', function () {
      var $p = $(this).closest('p');
      $p.slideUp('fast', function () { $(this).remove(); });
      return false;
    })
  });
})(jQuery);
