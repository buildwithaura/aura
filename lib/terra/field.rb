# Class: Field (Terra)
# A field.
#
# ## Description
# See {Terra} for information on how to use the form builder.
#
module Terra
  class Field
    attr_accessor :name
    attr_accessor :title
    attr_accessor :options

    def self.create(fieldset, type, name, title, options)
      klass = Fields::get(type) || Fields::Text
      klass.new(fieldset, name, title, options)
    end

    def initialize(fieldset, name, title, options={})
      @fieldset = fieldset
      @name     = name
      @title    = title
      @options  = options
    end

    # Attribute: fieldset (Terra::Field)
    # Returns the fieldset parent.
    attr_reader :fieldset

    # Attribute: form (Terra::Field)
    # Returns the parent Form.
    def form
      fieldset.form
    end

    def inspect
      "#<Field (#{self.class.to_s.split('::').last}): '#{name}'>"
    end

    # Method: id (Terra::Field)
    # Returns the HTML ID for the field.
    def id
      "field_#{name}"
    end

    # Method: label_html (Terra::Field)
    # Returns the HTML code for the <label> tag.
    def label_html
      "<label for='#{id}'>#{title}:</label>"
    end

    # Method: input_name (Terra::Field)
    # Returns the HTML name attribute for the field's input element.
    def input_name
      form.name_for name
    end

    # Method: input_html (Terra::Field)
    # Usage:  input_html(value='', item=nil)
    # Returns the HTML code for the input value.
    #
    # ## Description
    # If a `value` is supplied, it will be used for the value of the input
    # element.
    #
    def input_html(val='', item=nil)
      "<input id='#{id}' type='text' name='#{input_name}' value='#{h val}' />"
    end

    # Method: to_html (Terra::Field)
    # Usage:  to_html(value='', item=nil)
    # Returns the HTML code.
    #
    # ## Description
    # If a `value` is supplied, it will be used for the value of the input
    # element.
    #
    def to_html(val='', item=nil)
      html_wrap [ label_html, input_html(val, item=nil) ].join("\n")
    end

    # Method: html_wrap (Terra::Field)
    # Usage:  html_wrap(html)
    # Wraps the given HTML code with the field's field wrapper.
    #
    # ## Description
    # If you don't like `<p>` as the field wrapper, reimplement this.
    #
    def html_wrap(s)
      "<p class='#{options[:class] || ''}'>#{s}</p>"
    end

  protected
    def h(str)
      Rack::Utils.escape_html str.to_s
    end
  end
end

