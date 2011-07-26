title: Extensions
page_type: section
--
You may package your entire `app/` folder as an extension by copying it into
`extensions/my_extension/`. You may then redistribute it for using in other
Aura apps.

    $ ...
    extensions/
    '- my_extension/
       |- init/               - Initializers
       |- helpers/            - Helper methods (all *.rb autoloaded)
       |- models/             - Model files (all *.rb autoloaded)
       |- routes/             - Sinatra routes
       |- public/             - Raw files to be served
       |- tasks/              - Rake tasks (all *.rake autoloaded when doing `rake`)
       |- views/
       |- my_extension.rb     - Main file. Autoloaded when the extension is first loaded
       |- init.rb             - Loaded when everything else is set up already
       '- info.yml            - Metadata

(All files and folders above are optional. Just use what you need!)

 - Each extension can have `models/`, `routes/` and `helpers/` and
   all Ruby files inside them are autoloaded.
 - You may also have a YAML file called `info.yml`, which hosts metadata
   about your extension.
 - The directories described above are all optional.

## Extensions

Custom extensions go into `extensions/<extension_name>/`.
Here's what happens when the extension is loaded:

- After everything is set up, `extension_name.rb` is loaded.
- `init.rb` is called after all extensions are loaded.
- All Ruby files are loaded from `init/`, `models/`, `helpers/`, and `routes/`.

## Metadata

#### Defining metadata
Use `info.yml` in your extension.

    [extensions/twitter/info.yml (yaml)]
    name: Twitter integration
    author: Rico Sta. Cruz
    description: Shows twitter feeds in the home page.

## Loading extensions

#### Loading extensions
Edit `config/extensions.rb` of your app.

    [config/extensions.rb (ruby)]
    Main.configure do |m|
      m.set :additional_extensions, %w(default_theme)
    end
