# Class: Form (Terra)
# Terra is an HTML form generator.
#
# ## Description
# See {Terra} for information on how to use the form builder.
#
module Terra
  class Form
    def initialize
      @fieldsets = Hash.new
      fieldset(:default) { }
    end

    alias configure instance_eval

    # Method: fieldset (Terra::Form)
    # Usage:  fieldset(id, name=nil, options={}, &block)
    #
    # Defines a fieldset.
    #
    def fieldset(id, name=nil, options={}, &block)
      return @fieldsets[id]  unless block_given?

      @fieldsets[id] ||= Fieldset.new(self, id, name, options)
      @fieldsets[id].instance_eval &block
    end

    # Method: field (Terra::Form)
    # Usage:  field name, options
    # Defines a field.
    #
    # See {Terra::Fieldset.field} for details on how to use this.
    #
    def field(name, *a)
      if a.empty?
        set = fieldsets.detect { |set| set.field(name) }
        set.field(name)  unless set.nil?
      else
        fieldset(:default).field name, *a
      end
    end

    def method_missing(meth, *args, &blk)
      super  unless Fields.all.include?(meth)
      field meth, *args
    end

    # Method: fieldsets (Terra::Form)
    # Usage:  fieldsets
    #
    # Returns an array of fieldsets.
    #
    def fieldsets
      @fieldsets.values.sort_by { |fs| fs.to_s }
    end
  end
end
