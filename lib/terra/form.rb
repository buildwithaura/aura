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

    # Method: configure (Terra::Form)
    # Usage:  form.configure { ... }
    #
    # Adds fields to a form.
    #
    def configure(*a, &blk)
      instance_eval *a, &blk
      self
    end

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

    # Method: name_root (Terra::Form)
    # Usage:  name_root str
    #
    # Changes the root name to the given string.
    #
    # ## Description
    # The root name is the prefix for the `name` attributes.
    #
    #  * When invoked with a string, it changes the root name.
    #    Example: (`root_name 'editor'` => `<input name='editor[name]'>`)
    #
    #  * When invoked with an array, it changes the root names.
    #    Example: (`root_name %w(form user)` => `<input name='form[user][name]'>`)
    #
    #  * When invoked without arguments, it returns the root name.
    #
    def root_name(str=nil)
      @root_name ||= Array.new

      if str.is_a?(Array)
        @root_name = str
      elsif !str.nil?
        @root_name = [str]
      end

      @root_name
    end

    # Method: name_for (Terra::Form)
    # Usage:  name_for(string)
    #
    # Returns the name for a given field name.
    #
    # ##  Example
    #     root_name 'editor'
    #     name_for('email')    #=> 'editor[email]'
    #
    def name_for(str)
      names = (root_name + [*str])
      one = names[0]
      two = names[1..-1].map { |s| "[#{s}]" }.join('')

      "#{one}#{two}"
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
