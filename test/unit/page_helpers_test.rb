require 'test_helper'

class PageHelpersTest < Test::Unit::TestCase
  setup do
    @app = MockSinatra.new
    @app.extend Main::PageHelpers
  end

  test "body_class" do
    @app.production do |a|
      a.body_class 'form'
      a.body_class 'sidebar'
      assert_equal 'form sidebar', a.body_class 
    end
  end

  test "title" do
    @app.production do |a|
      a.title 'hi'
      assert_equal 'hi', a.title
    end
  end

  test "link_to" do
    @app.production do |a|
      link = a.link_to 'http://google.com'
      assert_equal '<a href="http://google.com"></a>', link

      link = a.link_to 'http://google.com', "G thing"
      assert_equal '<a href="http://google.com">G thing</a>', link

      link = a.link_to 'http://google.com', lambda { "Hello" }
      assert_equal '<a href="http://google.com">Hello</a>', link
    end
  end
end
