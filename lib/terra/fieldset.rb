module Terra
  class Fieldset
    def initialize(form, id, name=nil, options={})
      @form   = form
      @id     = id
      @name   = name
      @fields = []
    end

    # Add (or get?) a field
    def field(type, id=nil, title=nil, options={})
      return @fields.detect { |f| f.name == type }  if id.nil?
      @fields << Field.create(type, id, title, options)
    end

    def to_s
      @name || @id.to_s.capitalize
    end

    def inspect
      "#<Fieldset #{@id.inspect} [fields: #{fields.inspect}]>"
    end

    def default?
      @id == :default
    end

    def to_html(item=nil)
      [ "<fieldset name='#{id}'>",
        legend_html, fields_html(item),
        "</fieldset>" ].compact.join("\n")
    end

    def fields_html(item=nil)
      fields.map { |f| f.to_html(item.try(f.name.to_sym)) }.join("\n")
    end

    def legend_html
      "<h3 class='legend'>#{self.to_s}</h3>"  unless default?
    end

    attr_reader :fields
    attr_reader :id

    # Shortcuts for text, textarea, password..
    def method_missing(meth, *args, &blk)
      super  unless Fields.all.include?(meth)
      field meth, *args
    end
  end
end
