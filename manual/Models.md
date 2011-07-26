title: Models
page_type: section
--
## Description

All models are Sequel models. It uses the Sequel plugin system.

#### Creating a model
Subclass {Aura::Models::Model} in the *Aura::Models* namespace.

    [app/models/movie.rb (ruby)]
    module Aura::Models
      class Movie < Model
        # ...
      end
    end
  
#### Setting up auto-migration
Use Sequel's `set_schema`. Schemas defined this way will have it's tables automatically created.

    [app/models/movie.rb (ruby)]
    class Movie < Model
      set_schema do
        primary_key :id

        String :name
        String :description
      end
      
      # ...
    end

#### Setting up plugins

    [app/models/movie.rb (ruby)]
    class Movie < Model
      plugin :aura_editable
      plugin :aura_sluggable
    end

## Example

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

