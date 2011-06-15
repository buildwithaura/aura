;(function ($) {
  $('.crumbs .url .components, .crumbs .url a[href=#edit]').live('click', function () {
    var $url = $(this).closest('.url');
    $url.addClass('edit');
    $url.find('input').focus();
    return false;
  });

  $('.crumbs .url a[href=#set-as-homepage]').live('click', function () {
    alert("Not implemented yet -- for now, change the slug to 'home'.");
    return false;
  });

  $('.crumbs form.url').live('submit', function (e) {
    $(this).closest('.url').removeClass('edit');
    e.preventDefault(true);
  });

  $('.crumbs .url input').live('blur', function (e) {
    $(this).closest('.url').removeClass('edit');
    e.preventDefault(true);
  });

  $('.crumbs .url input').live('keydown', function (e) {
    if ((e.keyCode == 27) || (e.keyCode == 13) || (e.keyCode == 10)) {
      $(this).trigger('change');
      $(this).trigger('blur');
      e.preventDefault(true);
    }
  });

  $('.crumbs .url input').live('change', function (e) {
    var $input = $("#area form [name='editor[slug]']")
    if (!$input.length) { return; }

    var val = $(this).val();

    $input.val(val);

    var $slug = $(this).closest('.url').find('.this');
    if (val == '') { $slug.html("..."); }
    else { $slug.html(val); }

    e.preventDefault(true);
  });
})(jQuery);
