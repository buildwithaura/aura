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
    class Text < Field
    end

    class Password < Field
      def input_html(val='')
        "<input id='#{h id}' type='password' name='#{h input_name}' value='#{h val}'>"
      end
    end

    class Textarea < Field
      def input_html(val='')
        "<textarea id='#{h id}' type='text' name='#{h input_name}'>#{h val}</textarea>"
      end
    end

    class Checkbox < Field
      def to_html(val='')
        html_wrap [ input_html(val), label_html ].join("\n")
      end

      def input_html(val='')
        truthy = val && !val.empty?

        selected = ''
        selected = " selected='selected'"  if truthy

        inputs = [ "<input type='hidden' name='#{h input_name}' value='0'>" ]
        inputs+= [ "<input id='#{h id}' type='password' name='#{h input_name}' value='1'#{selected}>" ]

        inputs.join("\n")
      end
    end

    class Select < Field
      def input_html(val='')
        return input_html_radio(val)  if options[:type] == 'radio'
        input_html_select(val)
      end

      def input_html_select(val='')
        opts = @options[:options] || []
        select = [ "<select id='#{h id}' name='#{h input_name}'>" ]
        select+= opts.map { |opt|
          opt = opt.flatten  if opt.is_a? Hash
          key, val = opt

          selected = ''
          selected = ' selected="selected"'  if val.to_s == key.to_s

          "<option value='#{h key}'#{selected}>#{h key}</option>"
        }
        select+= [ "</select>" ]

        select.join("\n")
      end

      def input_html_radio(val='')
        opts = @options[:options] || []
        opts.map do |opt|
          opt = opt.flatten  if opt.is_a? Hash
          key, val = opt

          selected = ''
          selected = ' selected="selected"'  if val.to_s == key.to_s

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
