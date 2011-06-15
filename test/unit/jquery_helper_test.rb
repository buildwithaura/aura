require 'test_helper'

class JqueryHelperTest < Test::Unit::TestCase
  setup do
    @app = MockSinatra.new
    @app.extend Main::JqueryHelpers
  end

  should "jquery" do
    @app.production do |a|
      assert @app.jquery.match(/googleapis\.com/)
    end

    @app.development do |a|
      assert_equal "<script type='text/javascript' src='/js/jquery.js'></script>", @app.jquery
    end
  end
end
