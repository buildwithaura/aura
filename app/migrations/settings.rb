class Main
  migration "Aura v0.0.1 - settings" do
    database.create_table :settings do
      primary_key :id

      String :key
      String :value, :text => true
      index :key
    end
  end
end
