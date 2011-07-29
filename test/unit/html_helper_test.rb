require File.expand_path('../../test_helper', __FILE__)

class HtmlHelper < Test::Unit::TestCase
  include Main::HtmlHelpers

  test "test" do
    assert_equal "<x></x>", html("<x>")
  end

  test "markdown pre" do
    assert_equal html("<pre format=markdown>hi</pre>"), "<p>hi</p>"
  end

  test "markdown" do
    assert_equal html("<markdown>hi</markdown>"), "<p>hi</p>"
    assert_equal html("<markdown>hi</markdown>\n"), "<p>hi</p>"
    assert_equal html(" \n  <markdown>hi</markdown>  \n "), "<p>hi</p>"
  end

  test "stupidity" do
    assert_equal "<p>hi</p>", html("<p><pre format=markdown>hi</pre>")
    assert_equal "<p>hi</p>", html("<p></p><pre format=markdown>hi</pre><p></p>")
  end

  test "textile" do
    assert_equal html('<textile>"ab":/cd</textile>'), '<p><a href="/cd">ab</a></p>'
    assert_equal "<h2>Hello</h2>\n<p>Whats up?</p>", html("<textile>\nh2. Hello\n\nWhats up?\n</textile>")
  end
end
