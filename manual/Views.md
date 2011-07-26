title: Views
page_type: section
--
(TODO: make a sensible outline for these.)

## Using views

To create a view, put them in the `view/` folder of your extension.

    -# extension/myext/views/hello.haml
    %h1
      Hello, world!

Now call it in your Ruby code like so.

    # extension/myext/routes/hello.rb
    get '/hello' do
      show :hello
    end

Unlike Sinatra's `render`, using `show` will automatically try and find the file
in the view directories of all extensions, and guess the right filetype based
on the extension.

## Supported formats

Aura supports views in any format supported by Sinatra. You can try ERB, HAML, SASS, LESS

## Partials

Aura provides a `partial` helper.

    -# extension/myext/views/hello.haml
    %h1
      - partial :'hello/heading'

Now create your partial in another file:

    -# extension/myext/views/hello/heading.haml
    Hello world!

## View folders

View folders are at:

   extensions/*/views/
   app/views/

(TODO: explain show() and MultiView)
