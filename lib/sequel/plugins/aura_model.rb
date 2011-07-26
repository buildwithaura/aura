# Class: Model (Aura::Models)
# A class that represents a record type.
#
# ## Description
#    Inherits from {AuraModel}.

# Sequel plugin: AuraModel
# The base plugin for a model.
#
# ## Description
#    All models use this plugin, and all methods it provides are available
#    to all Aura/Sequel models.
#
module Sequel::Plugins::AuraModel
  def self.configure(model)
    model.plugin :validation_helpers
  end

  module InstanceMethods
    # Method: parent (AuraModel)
    # Returns the parent.
    #
    def parent
      nil
    end

    def to_s
      begin
        title
      rescue NoMethodError
        @values[:title] || self.class.to_s.split('::').last
      end
    end

    def validate!
      raise Sequel::ValidationFailed(errors)  unless valid?
    end

    # Method: shown_in_menu? (AuraModel)
    # Determines if the record should be shown to visitors in the site menus.
    #
    # ## Description
    # This only affects the front-facing site, and has to influence as
    # to whether it will be shown in the admin area.
    #
    # Override this.
    #
    def shown_in_menu?
      false
    end

    def <=>(other)
      self.sort_index <=> other.sort_index
    end

    # Method: sort_index (AuraModel)
    # This is what they'll be sorted by.
    #
    # To enable sorting, implement a `position` field.
    #
    # You can reimplement this. Make sure it returns a tuple of an int and an int.
    #
    def sort_index
      pos = nil
      pos ||= self.position  if self.respond_to?(:position)
      [pos || 9999, self.id]
    end

    # Method: set_fields (AuraModel)
    # Sets the fields to the values in the hash.
    #
    # Overriding `set_fields` to make the 2nd param optional.
    #
    def set_fields(hash, keys=hash.keys)
      super hash, keys
    end

    def templates_for(template)
      self.class.templates_for template
    end

    # Method: menu_title (AuraModel)
    # Returns the name of the record as it should appear on the menu.
    #
    # This defaults to whatever the title of the record is (`#to_s`).
    # Have your model override this if you need to.
    #
    def menu_title
      to_s
    end

    # Method: path (AuraModel)
    # Returns the URL path for the record.
    #
    # ##  Example
    #
    #     Page[1].path  #=> '/products/cx-300'
    #     User[1].path  #=> '/user/1' (because user is not sluggable.)
    #   
    #     Page[1].path(:edit)  # => '/products/cx-300/edit'
    #
    def path(*a)
      ret = "/#{self.class.class_name}/#{self.id}"
      ret += "/#{a.shift.to_s}"  if a.first.is_a?(String) || a.first.is_a?(Symbol)
      ret += "?" + Aura::Utils.query_string(a.shift)  if a.first.is_a?(Hash)
      ret
    end

    # Method: parentable? (AuraModel)
    # Determines if the record can have children.
    #
    # This is reimplemented by {AuraHierarchy}.
    #
    def parentable?
      false
    end
    
    # Method: parent? (AuraModel)
    # Determines if the record has a parent.
    #
    def parent?
      ! parent.nil?
    end

    # Method: children (AuraModel)
    # Returns the children of the record.
    def children
      Array.new
    end

    # Method: submenu (AuraModel)
    # Returns a list of items for the submenu.
    #
    # ##  Example
    #
    #     <% item.submenu.each do %>
    #       <li><% item.to_s %></li>
    #     <% end %>
    #
    def submenu
      children.select { |item| item.shown_in_menu? }.sort
    end

    # Method: crumbs (AuraModel)
    # Returns an array of records of breadcrumb path of the record, starting from the root.
    #
    def crumbs
      [self]
    end

    # Determines how far removed the record is from the root.
    #
    # ## Example
    #
    #     p = Page[1]
    #     p.parent?  #=> false
    #     p.depth    #=> 1
    #
    def depth
      crumbs.size
    end

    def is_parent_of?(target)
      target.crumbs.include?(self)
    end
  end

  module ClassMethods
    # Class method: content? (AuraModel)
    # Returns if the model data is considered to be site content.
    #
    # ## Description
    # The site is considered empty if all models that are content?
    # are empty.
    #
    def content?
      false
    end

    # Class method: roots (AuraModel)
    # Returns a set of results of all records that don't have parents.
    #
    # Returns a Sequel dataset.
    def roots
      select
    end

    # Class method: seed (AuraModel)
    # Ensures that the model has some bare essentials in it.
    #
    # This is called every time the application initializes.
    # Override this if you need certain records to exist, like as
    # how there is always one user.
    #
    # As this is called every application load, if you override this,
    # it is your responsibility to check if the model is #empty? before
    # writing anything.
    #
    # A parameter `type` may be given. If this is set to `:sample`, then
    # load up some sample data.
    #
    def seed(type=nil, &b)
    end

    # Class method: seed! (AuraModel)
    # Like `seed`, but empties the table first.
    #
    def seed!(type=nil, &b)
      delete
      seed type, &b
    end

    # Class method: parentable (AuraModel)
    # Determines if the model can have children.
    #
    # Reimplemented by aura_hierarchy.
    #
    def parentable?
      false
    end

    def templates_for(template)
      [ :"#{class_name}/#{template}",
        :"base/#{template}"
      ]
    end

    # Class method: class_name (AuraModel)
    # Returns a string of the model's name for use in URLs.
    #
    # ## Example
    #
    #     BlogPost.class_name #=> "blog_post"
    #
    def class_name
      self.to_s.demodulize.underscore
    end

    # Class method: title (AuraModel)
    # Returns a string of the model's name to appear on pages.
    #
    # ## Example
    #
    #     BlogPost.title #=> "Blog post"
    #
    def title
      self.class_name.humanize
    end

    # Class method: title_plural (AuraModel)
    # Returns a string of the model's name, pluralized, to appear on pages.
    #
    # ## Example
    #
    #     BlogPost.title_plural #=> "Blog posts"
    #
    def title_plural
      self.title.pluralize
    end

    # Class method: path (AuraModel)
    # Returns a URL path for an action for the model.
    #
    # ## Example
    #
    #     BlogPost.path               #=> /blog_post
    #     BlogPost.path(:list)        #=> /blog_post/list
    #     BlogPost.path(:list, :all)  #=> /blog_post/list/all
    #
    def path(*a)
      ret = "/#{class_name}"
      ret += "/#{a.shift}"  if a.first.is_a?(String) || a.first.is_a?(Symbol)
      ret += "?" + Aura::Utils.query_string(a.shift)  if a.first.is_a?(Hash)
      ret
    end
  end
end
