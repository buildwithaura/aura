# Ensure that Terra is loaded first.
require File.join(File.dirname(__FILE__), '../terra')

module Terra
  module Fields
    # Class: Html (Terra::Fields)
    # Inherits: {Terra::Field}
    # An HTML field.
    #
    class Html < Textarea
      def html_wrap(s)
        "<p class='html #{options[:class] || ''}'>#{s}</p>"
      end
    end
  end
end
