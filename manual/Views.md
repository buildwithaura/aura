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

## Partials

#### Using Partials
Aura provides a `partial` helper.

    [app/views/hello.haml (haml)]
    %hgroup
      != partial :'hello/heading', title: 'Hello'

#### Defining partials
    [extension/myext/views/hello/heading.haml (haml)]
    %h1= title

## Layouts

#### Defining layouts
Use the `layout` helper to define which layout will be used. This example will look for
a view called `cart.haml` (or any other layout extension).

    [app/views/cart/list.haml (haml)]
    - layout 'cart'

    %h1 Your shopping cart

#### Layout files
Layouts are ordinary view files that use `yield`.

    [app/views/cart.haml (haml)]
    !!! 5
    %html
      %title Shopping cart
      %body(class='cart')
        != yield

#### Nested layouts
You may nest layouts using the `layout` helper in layouts as well. This example
will place everything inside the `default.haml` layout.

    [app/views/cart.haml (haml)]
    - layout 'default'

    %section#cart
      != yield
    
## Content sections

#### Content sections
Aura uses `sinatra-content-for`. In your views, you can use the `content_for` helper.

    [app/views/cart/list.haml (haml)]
    - layout 'cart'

    - content_for :sidebar do
      %h3 Your cart
      %a(href='/checkout') Checkout
      %a(href='/') Continue shopping

#### Defining regions
In your layout, use `yield_content` to show the content for it.

    [app/views/cart.haml (haml)]
    %aside#sidebar
      != yield_content :sidebar


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
