class Main
  migration "Contact form v0.0.1 - create" do
    database.create_table :contact_forms do
      primary_key :id

      String :title
      String :slug
      
      String :form_fields, :text => true
    end
  end
end

