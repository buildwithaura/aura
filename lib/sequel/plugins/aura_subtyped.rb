# Sequel plugin: AuraSubtyped
# Ensures a model has subtypes.
#
module Sequel
module Plugins
module AuraSubtyped
  module InstanceMethods
    def template
      subtype.try(:template) || 'index'
    end

    # Method: subtype (AuraSubtyped)
    # Returns the subtype for the given page.
    #
    # ## Description
    #    Returns an {Aura::Subtype}, or nil.
    #
    def subtype
      return nil  if @values[:subtype].nil?
      self.class.subtype @values[:subtype].to_sym
    end
  end

  module ClassMethods
    def subtyped?
      true
    end

    # Class method: subtype_ (AuraSubtyped)
    # Returns the definition for a given subtype.
    #
    # ## Description
    # If options are given, sets the options for the given subtype.
    #
    # This can also be called as an instance method.
    #
    # ## Usage
    #     class Page
    #       subtype NAME,
    #         :name     => FULL_NAME,
    #         :template => TEMPLATE
    #     end
    #
    # ## Example
    #
    # #### Subtype example
    # This example defines a subtype called 'portfolio'.
    # The template it will use is `:page/portfolio`.
    #
    #     class Page
    #       subtype :portfolio,
    #         :name     => "Portfolio page",
    #         :template => "portfolio"
    #     end
    #
    def subtype(name, options=nil)
      @@subtypes ||= Hash.new

      return @@subtypes[name]  if options.nil?
      raise ArgumentError  unless options.is_a? Hash

      @@subtypes[name] = Aura::Subtype.new(options.merge({:id => name }))
    end

    def subtypes
      @@subtypes ||= Hash.new

      @@subtypes[:default] ||= Aura::Subtype.new :id => :default,
        :name     => 'Default',
        :template => 'index'

      @@subtypes.values.sort_by { |st| st._id.to_s }
    end
  end
end
end
end
