# Extensions

### How Aura is made up

Aura is a Sinatra app. It's structure is however a little unique: the
system is divided into little pieces called 'extensions'.

All extensions are in `core/` and `extensions/`, the former hosting
all the system extensions.

## What's an extension?

    extensions/
    '- my_extension/
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

## Extensions

Custom extensions go into `extensions/<extension_name>/`.
Here's what happens when the extension is loaded:

- After everything is set up, `extension_name.rb` is loaded.
  Load your classes here.

- `init.rb` is called after all extensions are loaded.

The files described above are all optional, and they all will go under
your extension's folder.

## Loading extensions

(Todo: insert a note here about to configure which extensions are loaded)

## Sinatra::MultiRenderExt

Aura includes a plugin Sinatra::MultiRenderExt which is built on top of
Sinatra's `render` system.

Using the `show()` helper (instead of `render`) will search all
view paths and template formats.

For instance, if you have:

    extensions/
    '- one/
    |  '- views/
    |     |- home.haml
    |     '- footer.haml
    '- two/
       '- views/
          '- header.erb

You can then use:

    show 'home'       # Finds one/views/home.haml
    show 'footer'     # Finds one/views/footer.haml
    show 'header'     # Finds two/views/header.erb

This is also done for partials:

    partial 'header'     # Finds views/header.erb
    partial 'header', :name => "Archer"

