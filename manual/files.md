title: File structure
page_type: section
--

#### Structure
Your project looks like this.

    myapp/
     |- app/
     |  |- css/          - CSS files
     |  |- js/           - JS files
     |  |
     |  |- models/       - Models
     |  |- helpers/      - Helpers
     |  |- routes/       - Sinatra Routes
     |  |- views/        - View files
     |  |
     |  |- init/         - Ruby files to be ran on app init
     |  `- migrations/   - Data migration files
     |
     |- config/          - User config
     |- public/          - Public files
     |
     |- config.ru
     |- Gemfile
     |- init.rb
     |- Rakefile
     `- README.md

