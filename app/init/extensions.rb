# Load extensions
Aura::Extension.active.each { |ext| ext.load! }

seed_file = Main.approot('config/seed.yml')

# If the file config/seed.yml is present, use that to initialize the DB.
# Only if the DB is pristine, though!
if File.exists?(seed_file) and !Aura::Models::Setting.table_exists?
  Aura.db_restore YAML::load_file(seed_file)

# ..otherwise, setup the database: do migrations and put in sample data.
else
  Aura::Models.all.each { |m| m.seed }
end

Aura::Models.unpack

Aura::Extension.active.each { |ext| ext.init }
