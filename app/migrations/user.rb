class Main
  migration "Aura v0.0.1 - user" do
    database.create_table :users do
      primary_key :id

      String :email
      String :slug
      String :crypted_password
      Time :last_login
    end
  end
end

