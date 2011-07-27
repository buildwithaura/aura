class ContactForm < Sequel::Model
  plugin :aura_sluggable      # Accessible via slug: /about-us/services
  plugin :aura_renderable     # Can show a page when accessed by that URL
  plugin :aura_editable
  #plugin :aura_hierarchy

  def self.show_on_sidebar?; true; end

  form do
    text :title, "Title", :class => 'title main-title'
    text :slug, "Slug", :class => 'compact hide'
  end
end
