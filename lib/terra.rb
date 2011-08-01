# Module: Terra
# Terra is a form builder.
# 
# #### Form DSL
# Configure your form with a Ruby DSL like so.
# 
#     form = Terra::Form.new
#     form.configure do
#       text :name, "Name"
#       text :email, "Email address"
# 
#       fieldset :options, "Options" {
#         textarea :body, "Body", :class => "hello"
#         select   :type, "Type",
#           :options => {
#             :red => "Red",
#             :blue => "Blue"
#           }
#       }
#     end
# 
# ## Using in Aura models
# 
# #### Using in Aura models
# In your models, simply use the `form` method to enclose
# the Terra form DSL in.
# 
#     class BlogPost < Sequel::Model
#       form {
#         text :title, "Title"
#         text :body,  "Body"
#       }
#     end
# 
# #### Accessing
# You'll then be able to access it like so:
# 
#     BlogPost.form
#     BlogPost.form.fieldsets
# 
# #### AuraEditable
# In Aura, by default, if you model uses the {AuraEditable} plugin,
# simply define a form and you'll have new/edit pages in the admin
# for your model, automagically.
#
#     [app/models/book.rb (rb)]
#     class Book < Sequel::Model
#       plugin :aura_editable
#
#       form {
#         # ...
#       }
#      end
# 
# ## Info
# 
# #### Defining fields
# Where `text` is the type of field, `:id` is the name of the
# field, `"Field name"` is what's to be displayed, and
# `{ options_hash }` is an optional list of settings. The field
# type can be any of `text`|`textarea`|`select`|`checkbox`.
# 
#     form {
#       text :id, "Field name", { options_hash }
#
#       textarea :body, "Body text"
#       select :category, "Category"
#     }
# 
# #### View example
# You'll then be able to use it in your views like so:
# 
#     [app/views/_form.haml (haml)]
#     - form.fieldsets.each do |set|
# 
#       -# The fieldset title
#       %h3= set.to_s
# 
#       -# Form fields (generates <p>..<label>..<input> for each field)
#       - set.fields.each do |field|
#         = field.to_html
# 
# ## Methods
#
# #### Form methods
# Here are some more useful {Terra::Form} methods.
# 
#     form.fieldsets                 # Returns an array of fieldsets
#     set = form.fieldset(:default)  # Returns a fieldset by name
# 
# #### Fieldset methods
# Here are some more useful {Terra::Fieldset} methods.
#
#     set.fields                # Returns a fieldset's fields
#     set.to_html               # Returns <fieldset>..</fieldset> HTML
#     set.to_html(object)       # Same as above, but tries to get data from `object.field_name`
#     set.name                  # Returns the name of the field
#     field = set.field(:name)  # Returns a field by name
# 
# #### Field methods
# Here are some more useful {Terra::Field} methods.
#
#     field.to_html             # <p>..<label>..<input>..</p>
#     field.to_html(val)        # Like above, but with a certain value
#     field.input_html          # just <input>
#     field.label_html          # just <label>
# 
# No, there's no `form.to_html`. Geez, don't even think about it--
# just render each of the fields/fieldsets.
# 
# ## In practice
#
# #### HAML example
# This is how you would render a form in HAML.
# 
#     [app/views/_form.haml (haml)]
#     %form{ :method => 'post', :action => '/save' }
#       - form.fieldsets.each do |set|
#         !~ set.to_html(@object)
#    
#       %p.submit
#         %button{ :type => 'submit' } Save
#    
#     # HAML tip: use !~ instead of = to have your textareas
#     # flow correctly by supressing HAML's extra whitespaces.
# 
# #### More
# 
#     [app/views/_form.haml (haml)]
#     = form.fieldsets.first.to_html
#     = form.fieldsets.first.fields.first.to_html
# 
#     = form.fieldset(:default).to_html
#     = form.fieldset(:default).field(:name).to_html
#     = form.fieldset(:default).field(:name).to_html("Hello") # value
# 
module Terra
  PREFIX = File.dirname(__FILE__)
  autoload :Field,    "#{PREFIX}/terra/field"
  autoload :Fields,   "#{PREFIX}/terra/fields"
  autoload :Fieldset, "#{PREFIX}/terra/fieldset"
  autoload :Form,     "#{PREFIX}/terra/form"
end

