title: Configuration
page_type: section
--

## Application configuration

#### Configuration
Configuration is done by Sinatra's app configuration on `Main`.

    Main.set :host, "Heroku"
    Main.get(:host)             #=> "Heroku"
    Main.host                   #=> "Heroku"
    Main.host?                  #=> true

#### The config folder
Configuration is usually stored in your app's `config/` folder as
plain `.rb` files.

    [config/database.rb (ruby)]
    Main.configure do |m|
      m.set :database_url, "sqlite://db/database.db"
    end

    # Just for the test environment
    Main.configure(:test) do |m|
      m.set :database_url, "sqlite://db/test.db"
    end

## Dynamic configuration

Aura has a small settings system for user-settable things that is separate from above.
All of these are stored in the database.

#### Using set and get
Use `Aura.set` and `Aura.get`. The value supports strings, integers, arrays
and hashes. (They are stored as YAML in the database.)

    Aura.set "site.name", "Jenny's Diary"
    Aura.set "site.description", "Thoughts of a 17-year-old"

    Aura.get("site.name")

