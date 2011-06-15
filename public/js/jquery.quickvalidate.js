;(function ($) {
  $.qvalidate = function() {};

  // Stop form submissions for forms that don't validate.
  // Trigger the `submit_error` event.
  //
  $('form:not(.skip-validation)').live('submit', function (e) {
    // Validate all fields that need validations.
    $(this).find('input, textarea, select').trigger('blur');

    // all .assert's that fail will have the class .error after validations.
    if ($(this).find('.error').length) {
      $(this).trigger('submit_error');
      $(this).find('.error').find('input, textarea, select').first().focus();
      e.stopPropagation();
      return false;
    }
  });

  // Do validations after every 'blur'.
  // Call the `validate` event for these; the event handlers will
  // be the ones to call the function validate().
  //
  // The function validate() will mark if fields are either errors
  // or ok's. This event handler either trigger the `assert_error`
  // or `assert_ok` on these fields, depending on the outcome.
  //
  $('.assert').find('input, textarea, select').live('blur', function () {
    var $p = $(this).closest('.assert');
    $p.trigger('validate', [$(this)]);

    var data = ($p.data('assert_data') || {});

    if (data.status == 'error') {
      $p.addClass('error');
      $p.trigger('assert_error', [data.type]);
    } else {
      $p.removeClass('error');
      $p.trigger('assert_ok', [data.type]);
    }

    $p.data('assert_data', null);
  });

  // Called by the `validate` event handlers.
  // If the given condition is false, mark it as an error.
  //
  function validate($p, condition, type) {
    var data = ($p.data('assert_data') || {});

    if (data.status != 'error') {
      data.type = type;
      data.status = condition ? 'ok' : 'error';
    }

    $p.data('assert_data', data);
  };

  /*
   * Validations
   */

  // Required fields
  $('.assert.required, .assert.present').live('validate', function (e, $input) {
    validate($(this), ($input.val() != ''), 'required');
  });

  // Numeric fields
  $('.assert.numeric').live('validate', function (e, $input) {
    validate($(this), $input.val().match(/^[0-9]*$/) !== null, 'numeric');
  });

  // Minimum lengths
  $('.assert[data-min-length]').live('validate', function (e, $input) {
    var len = $input.val().length;
    var min = parseInt($(this).attr('data-min-length'));
    validate($(this), (len >= min) || (len == 0), 'min-length');
  });

  // Matches next
  // Always paired with a `matches-previous`. Good for password fields.
  $('.assert.matches-next').live('validate', function () {
    var $p0 = $(this);
    var $p1 = $p0.nextAll('.assert.matches-previous').first();

    var $input1 = $p1.find('input, textarea, select');
    var $input0 = $p0.find('input');

    if (($input1.val() != '') || ($input0.val() == '')) {
      $input1.trigger('blur');
    }
  });

  // Matches previous
  // Always paired with a `matches-next`. Good for password fields.
  $('.assert.matches-previous').live('validate', function () {
    var $p1 = $(this);
    var $p0 = $p1.prevAll('.assert.matches-next').first();

    var $input0 = $p0.find('input, textarea, select');
    var $input1 = $p1.find('input');

    var condition = ($input0.val() == $input1.val());
    validate($p1, condition, 'matches');
  });

  /*
   * Default handlers
   */

  function onAssertError (e, type) {
    var msg = "";
    if (type == 'required')   { msg = "Required"; }
    if (type == 'min-length') { msg = "Should be at least " + $(this).attr('data-min-length') + " chars"; }
    if (type == 'numeric')    { msg = "Should be a number"; }
    if (type == 'matches')    { msg = "Doesn't match"; }

    var $n = $(this).find('.notice');

    if ($n.length) { $n.html(msg); }

    else {
      var t = $("<div class='notice'>" + msg + "</div>");
      $(this).append(t);
      t.hide().fadeIn();
    }
  };

  function onAssertOk (e, type) {
    var $n = $(this).find('.notice');
    if ($n) {
      $n.html("OK!");
      window.setTimeout(function () {
        $n.fadeOut(function () { $n.remove(); });
      }, 500);
    }
  };

  function onSubmitError () {
    alert("Please check your form for errors.");
  };

  function bindDefaults() {
    $('.assert')
      .live('assert_error', onAssertError)
      .live('assert_ok',    onAssertOk);

    $('form').live('submit_error', onSubmitError);
  }

  function unbindDefaults() {
    $('.assert')
      .die('assert_error', onAssertError)
      .die('assert_ok',    onAssertOk);

    $('form').die('submit_error', onSubmitError);
  }

  bindDefaults();

  // Export
  $.qvalidate.validate = validate;
  $.qvalidate.unbindDefaults = unbindDefaults;
})(jQuery);
