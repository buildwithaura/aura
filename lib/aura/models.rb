class Aura
  module Models
    extend self

    # Returns an array of all model classes.
    #
    # @example
    #
    #   content_models = Aura::Models.all.select { |m| m.content? }
    #
    def all
      constants.map { |cons| const_get(cons) }
    end

    # Returns a given model.
    #
    # Looks up the model @@name@@ and returns the model class, or @@nil@@
    # if it's not found.
    #
    # @param name [string] The model name.
    #
    # @example
    #
    #   Aura::Models.get('contact_form') #=> Aura::Model::ContactForm
    #
    def get(name)
      name = camelize(name)  if name.downcase == name
      begin
        const_get(name)
      rescue NameError
        nil
      end
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
