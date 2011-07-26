require File.expand_path('../../test_helper', __FILE__)

class FlashHelperTest < Test::Unit::TestCase
  setup do
    @app = MockSinatra.new
    @app.extend Main::FlashHelpers
  end

  test "flash errors" do
    @app.production do |a|
      assert ! a.flash_errors?

      a.flash_error "Amazing!"
      assert a.flash_errors?

      # Display the errors
      errors = a.flash_errors
      assert errors.is_a? Array
      assert ! a.flash_errors?
    end
  end

  test "flash" do
    @app.production do |a|
      assert ! a.flash_messages?

      a.flash_message "Amazing!"
      assert a.flash_messages?

      # Display the messages
      messages = a.flash_messages
      assert messages.is_a? Array
      assert ! a.flash_messages?
    end
  end
end
