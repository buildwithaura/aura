require File.expand_path('../../test_helper', __FILE__)

class HtmlHelper < Test::Unit::TestCase
  include Main::HtmlHelpers

  test "test" do
    assert_equal html("<x>"), "<x>"
    assert_equal html("<markdown>hi"), "<p>hi</p>"
    assert_equal html("<markdown>hi</markdown>"), "<p>hi</p>"
    assert_equal html("<markdown>hi</markdown>\n"), "<p>hi</p>"
    assert_equal html(" \n  <markdown>hi</markdown>  \n "), "<p>hi</p>"

    assert_equal html("<markdown>[a](/b)"), '<p><a href="/b">a</a></p>'
    assert_equal html('<textile>"ab":/cd'), '<p><a href="/cd">ab</a></p>'
  end
end
