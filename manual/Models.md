## Creating models

In your extension, create a model file like so.

    # extensions/myext/models/post.rb
    class Aura
      module Models
        class Post < Model
    
          # put guts here
          # for example:
    
          plugin :aura_editable
          plugin :aura_sluggable
    
          def shown_in_menu?() true; end
    
        end
      end
    end

## Sequel models

All models are Sequel models. It uses the sequel plugin system.

All models will automatically include the {Sequel::Plugins::AuraModel} plugin.

## Reference

Every Aura model has these functions.

- {Sequel::Plugins::AuraModel::ClassMethods AuraModel (class methods)}
- {Sequel::Plugins::AuraModel::InstanceMethods AuraModel (instance methods)}
