# Load extensions
Aura::Extension.active.each { |ext| ext.load! }

seed_file = Main.approot('config/seed.yml')

# If the file config/seed.yml is present, use that to initialize the DB.
# Only if the DB is pristine, though!
if File.exists?(seed_file) and Main.database.tables.empty?
  puts "Note: Restoring sample data from config/seed.yml."
  Aura.db_restore YAML::load_file(seed_file)

# ..otherwise, setup the database: do migrations and put in fresh data.
else
  Aura.run_migrations!
  Main.seed
end

Aura::Extension.active.each { |ext| ext.init }
