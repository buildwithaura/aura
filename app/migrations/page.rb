class Main
  migration "Aura v0.0.1 - page" do
    database.create_table :pages do
      # aura_hierarchy
      primary_key :id
      foreign_key :parent_id, :pages

      String :title
      String :body, :text => true
      String :custom, :text => true

      # aura_sluggable
      String :slug

      # aura_subtyped
      String :subtype

      String :author_name #unused

      String :meta_keywords
      String :meta_description

      Boolean :shown_in_menu

      Time :created_at
      Time :modified_at
    end
  end
end
