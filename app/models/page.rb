# Model: Page
# Inherits: {AuraModel} {AuraSluggable} {AuraRenderable} {AuraEditable} {AuraHierarchy} {AuraSubtyped}
# The page model.
#
# ## Inherits from
#  * {AuraModel}
#  * {AuraSluggable}
#  * {AuraRenderable}
#  * {AuraEditable}
#  * {AuraHierarchy}
#  * {AuraSubtyped}
#
class Page < Sequel::Model
  plugin :aura_sluggable      # Accessible via slug: /about-us/services
  plugin :aura_renderable     # Can show a page when accessed by that URL
  plugin :aura_editable       # Editable in the admin area
  plugin :aura_hierarchy      # Can have children
  plugin :aura_subtyped       # Has subtypes

  plugin :timestamps
  plugin :serialization, :yaml, :custom

  form do
    # title (show it big), main-title (use it on the page heading)
    text :title, "Page title", :class => 'title main-title no-label assert required'
    html :body,  "Body text", :class => 'long no-label'
    text :slug,  "Slug", :class => 'compact hide'

    fieldset(:meta, "Metadata") do
      text :meta_keywords, "Keywords", :class => 'compact-top'
      text :meta_description, "Description", :class => 'compact-bottom'
    end
  end

  def initialize(*a)
    super
    self.shown_in_menu = true  if self.shown_in_menu.nil?
  end

  def shown_in_menu?
    !! self.shown_in_menu
  end

  # Method: child_subtypes (Page)
  # Returns an array of Subtypes allowed for its children.
  def child_subtypes
    types = self.class.subtypes
    types.select! { |t| self.subtype.allowed_subtypes.include? t.id.to_sym }  if self.try(:subtype).try(:allowed_subtypes).is_a?(Array)
    types
  end

  # Method: subtypes (Page)
  # Returns an array of Subtypes allowed for this page.
  def subtypes
    parent? ? parent.child_subtypes : self.class.subtypes
  end

  # Method: parentable? (Page)
  # Checks if a given page can have children from the admin interface.
  def parentable?
    return false  if self.subtype && self.subtype.parentable? == false
    true
  end

  # Method: deletable? (Page)
  # Checks if a given page can be deleted from the admin interface.
  def deletable?
    return false  if self.subtype && self.subtype.deletable? == false
    true
  end

  def validate
    super
    validates_presence :title
  end

  # Returns the *other* form that depends on the subtype.
  def subform
    return nil  if subtype.nil?
    self.class.form subtype._id
  end

  # Class method: custom_field (Page)
  # Creates a custom field and adds getters/setters for it.
  #
  # ##  Example
  #
  # #### Creating custom fields
  #
  #     [app/models/page-ext.rb (rb)]
  #     class Page
  #       custom_field :recipe
  #     end
  #
  #     p = Page.new
  #     p.recipe = "Chili Con Carne"
  #
  def self.custom_field(name)
    name = name.to_sym
    self.send(:define_method, name) do
      self.custom[name]  if self.custom.is_a? Hash
    end

    self.send(:define_method, :"#{name}=") do |v|
      self.custom ||= Hash.new
      self.custom[name] = v
    end
  end

  def self.content?; true; end
  def self.show_on_sidebar?; true; end
end
