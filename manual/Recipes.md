title: Recipes
page_type: section
--
## Creating custom page types

#### Use subtype
In your model:

    class Aura::Models::Page
      subtype :portfolio,
        :name     => "Portfolio page",
        :template => "id_portfolio"

      custom_field :excerpt

      form :portfolio do
        text :excerpt, "Portfolio excerpt"
      end
    end

## Adding something to the admin sidebar

#### Adding models
If it's a model you want on there:

    class Aura::Models::MyModel
      def self.show_on_sidebar?; true; end
    end

#### The rest
For anything else, put this in your app's initializers. (See {Aura::Menu} for more info)

    [app/init/menu.rb (ruby)]
    Aura.admin_menu.add "id",
      :name => "My menu entry",
      :href => '/admin/foo',
      :icon => 'settings'

