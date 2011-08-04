# Module: Fields (Terra)
# A module that is the namespace for all types of fields.
#
# ## Description
# See {Terra} for information on how to use the form builder.
#
module Terra
  module Fields
    def all
      constants.map { |c| c.to_s.underscore.to_sym }
    end

    module_function :all

    def get(klass)
      begin
        const_get(klass.to_s.split('_').map { |s| s.capitalize }.join('').to_sym)
      rescue NameError
        nil
      end
    end

    module_function :get
  end
end

module Terra
  module Fields
    # Class: Text (Terra::Fields)
    # Inherits: {Terra::Field}
    # A text field.
    class Text < Field
    end

    # Class: Password (Terra::Fields)
    # Inherits: {Terra::Field}
    # A password field.
    class Password < Field
      def input_html(val='', item=nil)
        "<input id='#{h id}' type='password' name='#{h input_name}' value='#{h val}'>"
      end
    end

    # Class: Textarea (Terra::Fields)
    # Inherits: {Terra::Field}
    # A text area field.
    class Textarea < Field
      def input_html(val='', item=nil)
        "<textarea id='#{h id}' type='text' name='#{h input_name}'>#{h val}</textarea>"
      end
    end

    # Class: Checkbox (Terra::Fields)
    # Inherits: {Terra::Field}
    # A checkbox field.
    class Checkbox < Field
      def to_html(val='', item=nil)
        html_wrap [ input_html(val, item), label_html ].join("\n")
      end

      def input_html(val='', item=nil)
        truthy = val && !val.empty?

        selected = ''
        selected = " selected='selected'"  if truthy

        inputs = [ "<input type='hidden' name='#{h input_name}' value='0'>" ]
        inputs+= [ "<input id='#{h id}' type='password' name='#{h input_name}' value='1'#{selected}>" ]

        inputs.join("\n")
      end
    end

    # Class: Options (Terra::Fields)
    # Inherits: {Terra::Field}
    # A field for radio buttons or dropdowns.
    class Options < Field
      def input_html(val='', item=nil)
        return input_html_radio(val, item)  if options[:type].to_s == 'radio'
        input_html_select(val, item)
      end

      def input_html_select(val='', item=nil)
        opts = @options[:options] || []
        opts = opts.call(item)  if opts.respond_to?(:call)

        select = [ "<select id='#{h id}' name='#{h input_name}'>" ]
        select+= opts.map { |opt|
          opt = opt.flatten  if opt.is_a? Hash
          key, _ = opt

          selected = ''
          selected = " selected='selected'"  if val.to_s == key.to_s

          "<option value='#{h key}'#{selected}>#{h key}</option>"
        }
        select+= [ "</select>" ]

        select.join("\n")
      end

      def input_html_radio(val='', item=nil)
        opts = @options[:options] || []
        opts.map do |opt|
          opt = opt.flatten  if opt.is_a? Hash
          key, _ = opt

          selected = ''
          selected = " selected='selected'"  if val.to_s == key.to_s

          [ "<label for='#{h id}'>",
            "<input type='radio' id='#{h id}' name='#{h input_name}' value='#{h key}'#{selected}>",
            "<span>#{h val}</span>",
            "</label>"
          ]
        end.flatten.join("\n")
      end
    end
  end
end
