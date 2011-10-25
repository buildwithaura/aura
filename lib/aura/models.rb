# Class: Models (Aura)
# Models.
#
# #### Finding models
# `Aura.models` returns a Models instance, which is enumerable.
#
#     Aura.models    #=> #<Aura::Models>
#     Aura.models.map { |m| m.name }
#
# #### Find by name
# Use {Aura.models.get} or Ruby's `const_get`.
#
#     Aura.models.get('contact_form')       #=> ContactForm
#     Aura.models.const_get(:ContactForm)   #=> ContactForm
#
class Aura
  class Models
    include Enumerable

    def each(&blk)
      all.each &blk
    end

    # Class method: all (Aura::Models)
    # Returns an array of all model classes.
    #
    # ##  Example
    #     Aura.models.all.each do |m|
    #       # ...
    #     end
    #
    def all
      @@all ||= Array.new
    end

    # Class method: get (Aura::Models)
    # Returns a given model.
    #
    # ## Usage
    #     Aura::Models.get(name)
    #
    # ## Description
    #   Looks up the model `name` and returns the model class, or `nil`
    #   if it's not found.
    #
    # ##  Example
    #     Aura::Models.get('contact_form') #=> Aura::Model::ContactForm
    #
    def get(name)
      name = camelize(name)  if name.downcase == name
      begin
        Object.const_get(name)
      rescue NameError
        nil
      end
    end

    # Class method: reload! (Aura::Models)
    # Ensures that models will get new columns the next time it's loaded.
    #
    def reload!
      Aura.models.each { |m| m.send :set_columns, nil }
    end

    # Puts models in the global namespace.
    # Don't use me.
    #
    def unpack
      all.each do |model|
        klass = model.name.split('::').last
        Kernel.const_set(klass, model)  unless Kernel.const_defined?(klass)
      end
    end

  protected
    def camelize(str)
      str.split('_').map { |s| s.capitalize }.join('')
    end
  end
end
