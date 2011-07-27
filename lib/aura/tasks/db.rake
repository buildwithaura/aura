namespace :db do
  desc "Clears the database (no undo!)"
  task :flush do
    require ENV['APP_FILE']
    RakeStatus.heading :info, "Clearing the database..."
    Main.flush! { |*a| RakeStatus.print(*a) }
    Main.restart!
  end

  desc "Load sample values."
  task :sample do
    require ENV['APP_FILE']
    RakeStatus.heading :info, "Loading sample values..."
    Main.seed!(:sample) { |*a| RakeStatus.print(*a) }
    Main.restart!
  end

  desc "Dumps seed."
  task :dump do
    require ENV['APP_FILE']

    RakeStatus.heading :info, "Working..."
    output = Aura.db_dump_yaml

    RakeStatus.heading :info, "Writing to config/seed.yml..."
    File.open("config/seed.yml", 'w') { |f| f.write output }

    puts ""
    puts "Done."
    puts ""
    puts "The next time your app starts with a blank database, it will"
    puts "load the data you have now."
    puts ""
    puts "To disable this, remove the config/seed.yml file."
    puts ""
  end
end
