module Sequel
module Plugins
module AuraSubtyped
  module InstanceMethods
    def template
      subtype.try(:template) || 'id'
    end

    # Returns the subtype for the given page.
    # Returns an Aura::Subtype, or nil.
    def subtype
      return nil  if @values[:subtype].nil?
      self.class.subtype @values[:subtype].to_sym
    end
  end

  module ClassMethods
    def subtyped?
      true
    end

    # Returns the definition for a given subtype.
    # If options are given, sets the options for the given subtype.
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
        :template => 'id'

      @@subtypes.values.sort_by { |st| st._id.to_s }
    end
  end
end
end
end
