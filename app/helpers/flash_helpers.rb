class Main
  module FlashHelpers
    # Flash helper: flash_messages? (Helpers)
    # Checks if there are messages to flash.
    #
    # ## Description
    #    See {Helpers:flash_message} for an example.
    #
    def flash_messages?(key=:success)
      !(session[key].nil?)
    end

    # Flash helper: flash_messages (Helpers)
    # Returns a list of messages to flash.
    #
    # ## Description
    #    See {Helpers:flash_message} for an example.
    #
    def flash_messages(key=:success)
      ret = session[key]
      session.delete key
      [ret].flatten.compact
    end

    # Flash helper: flash_message (Helpers)
    # Flashes a message.
    #
    # #### Flash a message
    # Use `flash_message` in your routes to flash a message.
    #
    #     flash_message "Your changes have been saved."
    #
    # #### Showing messages
    # In your layouts, use `flash_messages` to show it.
    #
    #     [app/views/layout.haml (haml)]
    #
    #     - if flash_messages?
    #       #messages
    #         - flash_messages.each do |msg|
    #           %li= msg
    #
    #     - if flash_errors?
    #       #errors
    #         - flash_errors.each do |msg|
    #           %li= msg
    #
    def flash_message(msg, key=:success)
      session[key] ||= []
      session[key] = [session[key]]  unless session[key].is_a?(Array)
      session[key] << msg
    end

    # Flash helper: flash_errors? (Helpers)
    # Checks if there are errors to flash.
    #
    # ## Description
    #    See {Helpers:flash_message} for an example.
    #
    def flash_errors?
      flash_messages?(:error)
    end

    # Flash helper: flash_errors (Helpers)
    # Returns a list of errors to flash.
    #
    # ## Description
    #    See {Helpers:flash_message} for an example.
    #
    def flash_errors
      flash_messages(:error)
    end

    # Flash helper: flash_error (Helpers)
    # Flashes an error.
    #
    # ## Description
    #    See {Helpers:flash_message} for an example.
    #
    def flash_error(msg)
      flash_message msg, :error
    end
  end

  helpers FlashHelpers
end
