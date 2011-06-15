;(function ($) {
  // This is the glue file.
  // Most stuff here just glues together lib.* and jquery.* stuff.

  $.uiscreen.background = "";
  $.uiscreen.opacity = 0.8;
  $.uiscreen.fadeout_time = 0;

  // Focus
  $("textarea, input, select")
    .live('focus', function () {
      $('body').find('.focus').removeClass('focus');
      $(this).closest('form p').addClass('focus');
    })
    .live('blur', function () {
      $(this).closest('form p').removeClass('focus');
    });

  // Redudndant submit
  $("a[href=#submit]").live('click', function (e) {
    $("form").submit();
    return false;
  });

  // Preload of sorts
  $(function () { $("body").show().addClass("loaded"); });

  // Wysiwyg
  $("textarea.html, p.html textarea").livequery(function () {
    var $textarea = $(this);
    $(function(){ $textarea.auraWysiwyg(); });
  });

  // How to:
  // - area_class 'editable-title'
  // - in the form, set the class to 'main-title' for the main title
  //
  // Set your form to have a class 'main-title' to have this cool thing here
  // 
  $("#area.editable-title p.main-title").livequery(function () {
    var $p     = $(this);
    var $input = $p.find('input');
    var $title = $("#title .title-c");
    var $label = $p.find('label');
    var $h1    = $title.find('h1');

    var $newInput = $("<input type='text'>");
    $newInput.attr('value', $input.val());
    $newInput.attr('placeholder', $label.text().replace(/^\s*|:?\s*$/g,'').replace(/\s+/g,' '));

    $h1.remove();
    $p.hide();

    $title.append($newInput);

    function onChange() {
      $input.val($newInput.val());
    };

    $newInput.bind('keypress blur change', onChange);
  });
})(jQuery);
