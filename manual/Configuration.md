# Configuration

Configuration is done by Sinatra's app configuration; that is,
`Main.set :key, value`.

## The config folder

Here's what happens when the app first starts. These will happen
before any extensions are loaded:

 - The `config/` and `config/defaults` folder hosts a bunch of Ruby files.
 - `config/defaults/*.rb` are loaded first. This is in version control.
 - `config/*.rb` are loaded next. These are NOT in version control--these are 
 for your user-defined overrides.

## Defining configuration example

Lets make a new config file here called `config/gallery.rb`.

    # config/gallery.rb
    Main.configure do |m|
      m.set :gallery_default_name, "My Gallery"
      m.set :gallery_shown, true
    end

In your application, you will then be able to load them as so:

    theme = Main.gallery_default_theme

That's it!

## Settings in the database

Aura has a small settings system that is separate from above.
All of these are stored in the database.

    Aura.set "site.name", "Jenny's Diary"
    Aura.set "site.description", "Thoughts and meditations of a 17-year-old"

    Aura.get("site.name")

The value supports strings, integers, arrays and hashes. They
are stored as YAML in the database, so feel free to set values as hashes, 
arrays, etc.
