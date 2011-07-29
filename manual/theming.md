title: Theming
page_type: section
--
## Themes
#### Theming
Just change the views.

    $
    app/views/layout.haml
    app/views/page/show.haml

## CSS

#### Adding CSS
Put files in `app/css/`. You can put Sass, SCSS, Less or plain CSS files.

    [app/css/main.scss (css)]
    $red: #833;

    #main {
      color: $red;
    }

#### Accessing them
These files will be accessible in `http://localhost:4567/css`. For example,
these paths may correspond to the following files.

    $ http://localhost:4567/css/screen.css
    # ~/myapp/app/css/screen.css
    
    $ http://localhost:4567/css/main.css
    # ~/myapp/app/css/main.scss (Rendered by Sass CSS)

    $ http://localhost:4567/css/admin/top.css
    # ~/myapp/app/css/admin/top.less (Rendered by Less)

## JavaScript

#### Adding JavaScript
You may put files in `app/js/`. You can put CoffeeScript in here as well.

    [app/js/application.js (js)]
    $(function() {
      $("#top").show();
    });

#### Accessing them
These files will be accessible in `http://localhost:4567/js`. For example,
these paths may correspond to the following files.

    $ http://localhost:4567/js/prototype.js
    # ~/myapp/app/js/prototype.js
    
    $ http://localhost:4567/js/main.js
    # ~/myapp/app/js/main.coffee (Rendered by CoffeeScript)
