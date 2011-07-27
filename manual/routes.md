title: Routes
page_type: section
--
Routes are defined and used exactly as how you would in Sinatra.

#### Defining routes
Create a file in the `app/routes/` folder of your app.

    [app/routes/foo.rb (rb)]
    class Main
      get '/foo' do
        show :foo
      end
    end

#### Handling 404's
You should use `pass` instead of `not_found`. This lets the default
Aura routes pick it up in case it points to something else.

    [app/routes/foo.rb (rb)]
    class Main
      get '/book/:id' do |id|
        @book = Book[id] or pass

        # ...
      end
    end

#### Defining admin pages
Use the `show_admin` and `require_login` helpers.

    [app/routes/foo.rb (rb)]
    class Main
      get '/admin/something' do |id|
        require_login

        show_admin :something
      end
    end
