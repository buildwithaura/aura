title: Views
page_type: section
--
Aura has a unique way of handling views, different from Sinatra's `render`.

#### Creating views
To create a view, put them in the `view/` folder of your extension.

    [app/views/hello.haml (haml)]
    %h1
      Hello, world!

#### Showing views
Now call it in your Ruby code using `show`.
Unlike Sinatra's `render`, using `show` will automatically try and find the file
in the view directories of all extensions, and guess the right filetype based
on the extension.

    [app/routes/hello.rb (ruby)]
    get '/hello' do
      show :hello
    end

#### Using Partials
Aura provides a `partial` helper.

    [app/views/hello.haml (haml)]
    %hgroup
      != partial :'hello/heading', title: 'Hello'

#### Defining partials
    [extension/myext/views/hello/heading.haml (haml)]
    %h1= title

## View folders

Using `show` will find the file in all view directories. Those are:

 - Your app's view path (`app/views/`)
 - Views in your extensions
 - The default views in the Aura gem

#### Example
For instance, if you have this structure:

    extensions/
    '- one/
    |  '- views/
    |     |- home.haml
    |     '- footer.haml
    '- two/
       '- views/
          '- header.erb

#### for #show
You can then use:

    show :home       # Finds one/views/home.haml
    show :footer     # Finds one/views/footer.haml
    show :header     # Finds two/views/header.erb

#### for #partial
This is also done for partials:

    partial :header     # Finds views/header.erb
    partial :header, :name => "Archer"
