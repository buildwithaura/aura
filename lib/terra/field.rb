module Terra
  class Field
    attr_accessor :name
    attr_accessor :title
    attr_accessor :options

    def self.create(type, name, title, options)
      klass = Fields::get(type) || Fields::Text
      klass.new(name, title, options)
    end

    def initialize(name, title, options={})
      @name = name
      @title = title
      @options = options
    end

    def inspect
      "#<Field (#{self.class.to_s.split('::').last}): '#{name}'>"
    end

    def id
      "field_#{name}"
    end

    def label_html
      "<label for='#{id}'>#{title}:</label>"
    end
    def input_name
      "editor[#{name}]"
    end

    def input_html(val='')
      "<input id='#{id}' type='text' name='#{input_name}' value='#{h val}' />"
    end

    def to_html(val='')
      html_wrap [ label_html, input_html(val) ].join("\n")
    end

    def html_wrap(s)
      "<p class='#{options[:class] || ''}'>#{s}</p>"
    end

  protected
    def h(str)
      Rack::Utils.escape_html str
    end
  end
end

