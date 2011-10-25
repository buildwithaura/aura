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

    if ($area.scrollTop() < top)
      $area.animate({ scrollTop: top });
  });

  $.fn.auraWysiwyg = function () {
    var w = $(this).wysiwyg({
      css: '/css/admin/wysiwyg_field.css',
      rmUnusedControls: true,
      initialContent: '',
      controls: {
        bold: { visible: true },
        italic: { visible: true },
        underline: { visible: true },
        indent: { visible: true },
        outdent: { visible: true },
        insertOrderedList: { visible: true },
        insertUnorderedList: { visible: true },
        h2: { visible: true },
        h3: { visible: true },
        paragraph: { visible: true },
        html: {
          visible: true,
          exec: function() {
            var elementHeight;

            if (this.options.resizeOptions && $.fn.resizable) {
              elementHeight = this.element.height();
            }

            if (this.viewHTML) {
              this.setContent(this.original.value);

              $(this.original).hide();
              this.editor.show();

              if (this.options.resizeOptions && $.fn.resizable) {
                // if element.height still the same after frame was shown
                if (elementHeight === this.element.height()) {
                  this.element.height(elementHeight + this.editor.height());
                }

                this.element.resizable($.extend(true, {
                  alsoResize: this.editor
                }, this.options.resizeOptions));
              }

              $(this.element).find('.toolbar-two').hide();
              $(this.element).find('.toolbar').show();
              
              // this.ui.toolbar.find("li").each(function () {
              //   var li = $(this);

              //   if (li.hasClass("html")) {
              //     li.removeClass("active");
              //   } else {
              //     li.removeClass('disabled');
              //   }
              // });
            } else {
              this.saveContent();

              $(this.original).css({
                width:	this.element.outerWidth(),
                height: this.element.height() - this.ui.toolbar.height() - 10,
                resize: "none"
              }).show().css({ display: 'block' });
              this.editor.hide();

              var self = this;

              setTimeout(function() { $(self.original).focus(); }, 1);
              
              if (this.options.resizeOptions && $.fn.resizable) {
                // if element.height still the same after frame was hidden
                if (elementHeight === this.element.height()) {
                  this.element.height(this.ui.toolbar.height());
                }

                this.element.resizable("destroy");
              }

              $(this.element).find('.toolbar').hide();
              $(this.element).find('.toolbar-two').show();
              // this.ui.toolbar.find("li").each(function () {
              //   var li = $(this);

              //   if (li.hasClass("html")) {
              //     li.addClass("active");
              //   } else {
              //     if (false === li.hasClass("fullscreen")) {
              //       li.removeClass("active").addClass('disabled');
              //     }
              //   }
              // });
            }

            this.viewHTML = !(this.viewHTML);
          }
        }
      }
    });

    var $div = $(this).closest('p').find('div.wysiwyg');

    // Make toolbar 2
    var $a = $("<a class='back-to-rtf'>");
    var $tool2 = $("<div class='toolbar-two'>");
    $tool2.append("<span>You are editing raw HTML. </span>");
    $tool2.append($a);
    $a.html("Back to WYSIWYG");
    $a.click(function() {
      $div.find('.toolbar .html').trigger('click');
    });

    $div.prepend($tool2);
    $tool2.hide();

    // Default to HTML view if it's a textile/markdown thing
    if ($(this).val().match(/format=/)) {
      $div.find('.toolbar .html').trigger('click');
      $(this).val($(this).val().replace(/<p><\/p>/g, ''));
    }
  };
})(jQuery);
