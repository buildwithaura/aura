;(function ($) {
  // iFrame focus
  $("div.wysiwyg iframe").livequery(function () {
    var $p = $(this).closest('p');

    function callback () {
      $p.trigger('focus');
    }

    this.contentWindow.document.onfocus = callback;
    this.contentWindow.onfocus = callback;
    $p.bind('click', callback);
  });

  $("p.html").live('focus', function () {
    var $p    = $(this);
    var $form = $p.closest('form');

    $form.find('.focus').removeClass('focus');
    $p.addClass('focus');

    var $area = $('#area');
    var top   = 0;

    if ($('.message').length) {
      top  = $('.message').outerHeight() + $('.message').position().top;
    }
    else if ($('section.crumbs').length) {
      top  = $('section.crumbs').outerHeight();
    }

    $area.animate({ scrollTop: top });
  });

  $.fn.auraWysiwyg = function () {
    $(this).wysiwyg({
      css: '/css/admin/wysiwyg_field.css',
      controls: {
        strikeThrough: { visible: false },
        subscript: { visible: false },
        superscript: { visible: false },
        separator03: { visible: false },
        undo: { visible: false },
        redo: { visible: false },
        separator04: { visible: false },
        cut: { visible: false },
        copy: { visible: false },
        paste: { visible: false },
        html: {
          visible: true,
          exec: function() {
            // Put the original inside.
            if (!$(this.original).closest('div.wysiwyg').length) {
              var $div = $(this.editor).closest('div.wysiwyg');
              $div.append($(this.original));
            }

            if (this.viewHTML) {
              this.setContent($(this.original).val());
              $(this.original).hide();
              $(this.editor).show();
              this.focus();
            }

            else {
              this.saveContent();
              $(this.editor).hide();
              $(this.original).show().focus();
            }

            this.viewHTML = !( this.viewHTML );
          }
        }
      }
    });
  };
})(jQuery);
