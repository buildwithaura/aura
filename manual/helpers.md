title: Helpers
page_type: section
--
Helpers are defined and used exactly as how you would in Sinatra.

#### Defining helpers
Create a file in the `app/helpers/` folder of your app.

    [app/helpers/my_helpers.rb (rb)]
    class Main
      module MyHelpers
        def who_is_awesome
          "You are!"
        end
      end

      helpers MyHelpers
    end

#### Using helpers in views
You can then use it in views.

    [app/views/index.haml (haml)]
    %div.question
      Who is awesome?

    %div.answer
      = who_is_awesome

#### Using helpers in routes
Yeah, you can.

    [app/routes/foo.rb (rb)]
    class Main
      get '/who_is_awesome' do
        @who = who_is_awesome
        show :index
      end
    end
