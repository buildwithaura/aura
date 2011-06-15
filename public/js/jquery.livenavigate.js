// In-page navigation that doesn't break the back button and actually changes
// the URL.
//
// What it solves:
//
//   The usual approach to single-page apps are URL's like
//   `http://domain.com/#!1938/article`. Livenavigate does the same thing,
//   except that it your URL will be `http://domain.com/1938/article`, yet
//   everything will be in-place via AJAX.
//
//   This is only supported if your browser supports history states (FF4/Safari).
//   Don't worry though--it will fallback to the hashbang method otherwise.
//
//   For hashbang URL's, this relies on the awesome jQuery.hashListen. It
//   uses the hash change event, and falls back to window timers if it's not
//   available.
//
//   End result: in-place navigation with nice URL's, no matter what browser.
//
// Usage:
//
//   /* Bind this to like, say, <a> links */
//   $.navigate('/admin/products');
//
// If the history states are available (Safari/FF4), it will change the actual URL
// of the page, yet still /not/ load the URL directly (but instead just trigger the
// `navigate` event).
//
//   /* Here's how you listen to new pages */
//   $(window).bind('navigate', function (e, href) {
//     /* href == '/admin/products' */
//   });
//
// If history states are not available, it will fall back to hashListen.
//
;(function ($) {
  if (window.history.pushState) {
    $.navigate = function (href) {
      window.history.pushState({ href: href }, "", href);
      $(window).trigger('navigate', href);
    };

    window.onpopstate = function (e, state) {
      $(window).trigger('navigate', window.location.pathname);
    };
  }

  else {
    $.navigate = function (href) {
      if (window.location.hash == '#!'+href) { return; }
      window.location.hash = "#!" + href;
    };

    $.hashListen('!(.*)', function (href) {
      $(window).trigger('navigate', href);
    });
  };
})(jQuery);
