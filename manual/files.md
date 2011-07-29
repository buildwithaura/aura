title: File structure
page_type: section
--
This is what your default project looks like when you use `aura new`.

#### Structure
Your project looks like this. Most it's guts will be in `app/`.

    [(text)]
    project/
     |- app/
     |  |- css/          #  CSS files
     |  |- js/           #  JS files
     |  |
     |  |- models/       #  Models
     |  |- helpers/      #  Helpers
     |  |- routes/       #  Sinatra Routes
     |  |- views/        #  View files
     |  |
     |  |- init/         #  Ruby files to be ran on app init
     |  |- migrations/   #  Data migration files
     |
     |- config/          #  User config
     |- public/          #  Public files
     |
     |- config.ru
     |- Gemfile
     |- init.rb
     |- Rakefile
     |- README.md

## app/

#### app/css/
This contains your CSS files. Anything here will be accessible via `/css`.

    app/css/style.css
    app/css/theme/screen.sass
    app/css/theme/print.css

#### app/js/
JavaScript files. They will be accessible via `/js`.

    app/js/application.js

#### app/models/
Models here. All Ruby files here will be loaded on app init.

    app/models/page.rb
    app/models/book.rb
    app/models/movie.rb

#### app/helpers/
Helpers here. All Ruby files here will be loaded on app init.

    app/helpers/page_helpers.rb
    app/helpers/time_helpers.rb

#### app/routes/
Sinatra routes here. All Ruby files here will be loaded on app init.

    app/routes/store.rb
    app/routes/background.rb

    # Example:
    class Main
      get '/foo' do
        show :foo
      end
    end
