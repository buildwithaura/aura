Terra
=====

Terra is an HTML form generator.

## Example

Configure your form with a Ruby DSL like so.

    form = Terra::Form.new
    form.configure {
      text :name, "Name"
      text :email, "Email address"

      fieldset :options, "Options" {
        textarea :body, "Body", :class => "hello"
        select   :type, "Type",
          :options => {
            :red => "Red",
            :blue => "Blue"
          }
      }
    }

## Info

The syntax to define fields is:

    text :id, "Field name", { options_hash }

Where `text` is the type of field, `:id` is the name of the
field, `"Field name"` is what's to be displayed, and
`{ options_hash }` is an optional list of settings. The field
type can be any of `text`|`textarea`|`select`|`checkbox`.


## Example

You'll then be able to use it in your views like so:

    - form.fieldsets.each do |set|

      -# The fieldset title
      %h3= set.to_s

      -# Form fields (generates <p>..<label>..<input> for each field)
      - set.fields.each do |field|
        = field.to_html

## Some methods

Here are some more useful methods:

    form.fieldsets                 # Returns an array of fieldsets
    set = form.fieldset(:default)  # Returns a fieldset by name

    set.fields                # Returns a fieldset's fields
    set.to_html               # Returns <fieldset>..</fieldset> HTML
    set.to_html(object)       # Same as above, but tries to get data from `object.field_name`
    set.name                  # Returns the name of the field
    field = set.field(:name)  # Returns a field by name

    field.to_html             # <p>..<label>..<input>..</p>
    field.to_html(val)        # Like above, but with a certain value
    field.input_html          # just <input>
    field.label_html          # just <label>

No, there's no `form.to_html`. Geez, don't even think about it--
just render each of the fields/fieldsets.

## In practice

    %form{:method => 'post', :action => '/save'}
      - form.fieldsets.each do |set|
        !~ set.to_html(@object)
   
      %p.submit
        %button{:type => 'submit'} Save
   
    # HAML tip: use !~ instead of = to have your textareas
    # flow correctly by supressing HAML's extra whitespaces.

### More

    = form.fieldsets.first.to_html
    = form.fieldsets.first.fields.first.to_html

    = form.fieldset(:default).to_html
    = form.fieldset(:default).field(:name).to_html
    = form.fieldset(:default).field(:name).to_html("Hello") # value

## Using in Aura

In your models, simply use the `form` method to enclose
the Terra form DSL in.

    class BlogPost < Model
      form {
        text :title, "Title"
        text :body,  "Body"
      }
    end

You'll then be able to access it like so:

 - `BlogPost.form`
 - `BlogPost.form.fieldsets`

In Aura, by default, if you model uses the `editable` plugin,
simply define a form and you'll have new/edit pages in the admin
for your model, automagically. (`plugin :aura_editable`)

