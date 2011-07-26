title: Recipes
page_type: section
--
## Creating extensions

(See {file:Extensions.md Extensions} for more info.)

Step 1: Make the folder `extensions/my_extension/`. All of these files and 
folders are optional.

    ./
    `- extensions/
       `- my_extension/
          |
          |- info.yml           - Description of the extension
          |- init.rb            - The main file to be loaded
          |
          |- models/            - Models (all files auto loaded)
          |- helpers/           - Helpers (Auto-loaded)
          |- routes/            - Routes  (Auto-loaded)
          |
          |- views/             - HAML's and stuff
          |  `- css/            - CSS (any `foo.scss` here will be accessible 
          |                            as `yoursite.com/css/foo.css`)
          |
          `- public/            - Everything here will be accessible

Step 2: Add the extension to `config/extensions.rb` under 
`additional_extensions`.  If this file doesn't exist, copy it from 
`config/defaults/`.

# Creating a theme

A theme is just an extension.

- Make an extension that has a `mytheme/views/` folder
- Make up a `mytheme/views/layout.haml`
- Override the look of a page in `mytheme/views/base/default.haml`
- Put public stuff (images et al) in `mytheme/public/`
- Put CSS files in `mytheme/views/css/`

# Creating custom page types

    class Aura::Models::Page
      subtype :portfolio,
        :name     => "Portfolio page",
        :template => "id_portfolio"

      custom_field :excerpt

      form :portfolio do
        text :excerpt, "Portfolio excerpt"
        end
    end

# Adding something to the admin sidebar

If it's a model you want on there:

   class Aura::Models::MyModel
     def self.show_on_sidebar?; true; end
   end

Something else:

   # extensions/my_extension/init.rb
   Aura::Admin.menu.add "id",
     :name => "My menu entry",
     :href => '/admin/foo',
     :icon => 'settings'

