# Module: Models (Aura)
# The namespace for models.
#
# #### Creating a model
# Subclass {Aura::Models::Model} in the *Aura::Models* namespace.
#
#     module Aura::Models
#       class Movie < Model
#         # ...
#       end
#     end
#   
# #### Finding models
# Use {Aura::Models.all}.
#
#     Aura::Models.all.map { |m| m.name }
#
# #### Find by name
# Use {Aura::Models.get} or Ruby's `const_get`.
#
#     Aura::Models.get('contact_form')       #=> Aura::Models::ContactForm
#     Aura::Models.const_get(:ContactForm)   #=> Aura::Models::ContactForm
#
class Aura
  module Models
    extend self

    # Class method: all (Aura::Models)
    # Returns an array of all model classes.
    #
    # ##  Example
    #     Aura::Models.all.each do |m|
    #       # ...
    #     end
    #
    def all
      constants.map { |cons| const_get(cons) }
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
        const_get(name)
      rescue NameError
        nil
      end
    end

    # Class method: reload! (Aura::Models)
    # Reloads models
    #
    def reload!
      constants.each { |c| self.send :remove_const, c }

      files  = Array.new
      files << Aura.gem_root('app/models/**/*.rb')
      files << Aura.root('app/models/**/*.rb')
      files += Extension.active.map { |e| e.path('models/**/*.rb') }

      # Find and load all
      files = files.compact.map { |spec| Dir[spec].sort }.flatten.uniq
      files.each { |f| load f }
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
