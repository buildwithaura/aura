;(function ($) {
  var $nav  = $("#nav"),
      $area = $("#area"),
      $body = $("body"),
      $title= $("#title"),
      $top  = $("#top"),
      $context = $nav.add($area);

  var sidebarWidth = 200;

  function onResize() {
    var height = $(window).height();
    height -= $top.outerHeight();

    var titleHeight = $title.outerHeight();
    if (!$("#title").html().match(/\S/)) { titleHeight = 0; }

    // Stretch heights.
    $nav .css({ 'height': height });
    $area.css({ 'height': height - titleHeight });
    $area.css({ top: $top.outerHeight() + titleHeight });

    // Widths of area and title
    var padding = 0;
    if (!$nav.is(':hidden')) { padding += $nav.outerWidth(); }
    $area.add($title)
      .css({ width: $(window).width() - padding, left: padding })
  }

  $(function () {
    $(document.body).show();
    $('body').addClass('fixed-layout');
    if ($('#area').is('.no-sidebar')) { $.sidebar.hide(); }
    $(window).resize(onResize);
    onResize();
  });

  $.sidebar = function () { };

  $.sidebar.hide = function () {
    $body.addClass('no-sidebar');
    $nav.hide();
    $area.css({ left: 0 });
    onResize();
  };

  $.sidebar.show = function () {
    $body.removeClass('no-sidebar');
    $nav.show();
    $area.css({ left: sidebarWidth });
    onResize();
  };
})(jQuery);
