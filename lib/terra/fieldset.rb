# Class: Fieldset (Terra)
# A fieldset.
#
# ## Description
# See {Terra} for information on how to use the form builder.
#
module Terra
  class Fieldset
    def initialize(form, id, name=nil, options={})
      @form   = form
      @id     = id
      @name   = name
      @fields = []
    end

    # Method: field (Terra::Fieldset)
    # Add (or get?) a field.
    #
    def field(type, id=nil, title=nil, options={})
      return @fields.detect { |f| f.name == type }  if id.nil?
      @fields << Field.create(type, id, title, options)
    end

    # Method: to_s (Terra::Fieldset)
    # Returns the name of the field.
    def to_s
      @name || @id.to_s.capitalize
    end

    def inspect
      "#<Fieldset #{@id.inspect} [fields: #{fields.inspect}]>"
    end

    # Method: default? (Terra::Fieldset)
    # Returns true if the fieldset is the default fieldset of the form.
    def default?
      @id == :default
    end

    # Method: to_html (Terra::Fieldset)
    # Returns the HTML code for the entire fieldset.
    #
    # ## Description
    # This calls puts together {Terra::Fieldset#legend_html} and
    # {Terra::Fieldset#fields_html} inside a `<fieldset>` tag.
    #
    def to_html(item=nil)
      [ "<fieldset name='#{id}'>",
        legend_html, fields_html(item),
        "</fieldset>" ].compact.join("\n")
    end

    # Method: fields_html (Terra::Fieldset)
    # Returns the HTML code for the fields in the fieldset.
    def fields_html(item=nil)
      fields.map { |f| f.to_html(item.try(f.name.to_sym)) }.join("\n")
    end

    # Method: legend_html (Terra::Fieldset)
    # Returns the HTML code for the fields in the fieldset.
    def legend_html
      "<h3 class='legend'>#{self.to_s}</h3>"  unless default?
    end

    # Attribute: fields (Terra::Fieldset)
    # The list of fields.
    attr_reader :fields

    # Attribute: id (Terra::Fieldset)
    # The symbol name of the field.
    attr_reader :id

    # Shortcuts for text, textarea, password..
    def method_missing(meth, *args, &blk)
      super  unless Fields.all.include?(meth)
      field meth, *args
    end
  end
end
