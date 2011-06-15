class Aura
module Models
class ContactForm < Model
  set_schema do
    primary_key :id

    String :title
    String :slug
    
    String :form_fields, :text => true
  end

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
end
end
