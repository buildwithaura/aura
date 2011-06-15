module Terra
  class Form
    def initialize
      @fieldsets = Hash.new
      fieldset(:default) { }
    end

    alias configure instance_eval

    def fieldset(id, name=nil, options={}, &block)
      return @fieldsets[id]  unless block_given?

      @fieldsets[id] ||= Fieldset.new(self, id, name, options)
      @fieldsets[id].instance_eval &block
    end

    # Forwardable
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

    def fieldsets
      @fieldsets.values.sort_by { |fs| fs.to_s }
    end
  end
end
