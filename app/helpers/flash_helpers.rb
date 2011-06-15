class Main
  module FlashHelpers
    def flash_messages?(key=:success)
      !(session[key].nil?)
    end

    def flash_messages(key=:success)
      ret = session[key]
      session.delete key
      [ret].flatten.compact
    end

    def flash_message(msg, key=:success)
      session[key] ||= []
      session[key] = [session[key]]  unless session[key].is_a?(Array)
      session[key] << msg
    end

    def flash_errors?
      flash_messages?(:error)
    end

    def flash_errors
      flash_messages(:error)
    end

    def flash_error(msg)
      flash_message msg, :error
    end
  end

  helpers FlashHelpers
end
