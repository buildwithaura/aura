class Aura
  PREFIX = File.dirname(__FILE__)

  autoload :Admin,              "#{PREFIX}/aura/admin"
  autoload :Extension,          "#{PREFIX}/aura/extension"
  autoload :ExtensionNotFound,  "#{PREFIX}/aura/extension"
  autoload :Menu,               "#{PREFIX}/aura/menu"
  autoload :Models,             "#{PREFIX}/aura/models"
  autoload :Slugs,              "#{PREFIX}/aura/slugs"
  autoload :Subtype,            "#{PREFIX}/aura/subtype"
  autoload :Seeder,             "#{PREFIX}/aura/seeder"
  autoload :Utils,              "#{PREFIX}/aura/utils"
  autoload :Editor,             "#{PREFIX}/aura/editor"

  require "#{PREFIX}/aura/version"

  Model = Sequel::Model

  # @group Settings

  # Alias for Setting.get.
  # See Setting.get for an example.
  def self.get(key)
    Models::Setting.get key
  end

  # Alias for Setting.set.
  # See Setting.get for an example.
  def self.set(key, value)
    Models::Setting.set key, value
  end

  # Alias for Setting.default.
  # See Setting.get for an example.
  def self.default(key, value)
    Models::Setting.default key, value
  end

  # Alias for Setting.delete.
  # See Setting.get for an example.
  def self.del(key)
    Models::Setting.del key
  end

  # @group Database handling

  # Returns the database backup as a hash.
  #
  # @see db_dump_yaml
  #
  # @example
  #
  #   data = Aura.db_dump
  #   yml_data = YAML::dump(data) # also see db_dump_yaml.
  #   File.open('backup.yml', 'w') { |f| f << yml_data }
  #   puts yml_data.inspect
  #
  #   # Sample output:
  #   # pages:
  #   #   - title: Hello.
  #   #     body: Good day everyone!
  #   #   - title: Cheers!
  #   #     body: What's going on?
  #   # settings:
  #   #   - ...
  #
  def self.db_dump
    db = Models.all.first.db

    Models.all.inject({}) { |hash, model|
      table = model.table_name
      hash[table] = db[table].all
      hash
    }
  end

  # Restores a previous output of db_dump.
  #
  # This function takes in the parameter @@hash@@, which is a hash table
  # with the keys as the table names, and it's values are arrays of
  # records.
  # 
  # See #db_dump for an example of the hash that #db_restore expects.
  #
  # @example
  #
  #   # Load a previously saved copy of the hash, as spitted out
  #   # by db_dump.
  #   yaml_data = YAML::load_file 'backup.yml'
  #
  #   # Load it.
  #   Aura.db_restore(yaml_data)
  #
  def self.db_restore(hash)
    # Hash format:
    # { :table_name => [ array of hashes of rows ], ... }

    # Bring the DB back to the state where we have tables ready.
    Main.flush!
    Models.all.each { |m| m.sync_schema }
    db = Models.all.first.db

    hash.each do |table, entries|
      entries.each do |entry|
        db[table] << entry
      end
    end
  end

  # Returns the database backup as a YAML document.
  #
  def self.db_dump_yaml
    require 'yaml'
    YAML::dump db_dump
  end

  # @group Site content

  # Checks if the site is empty.
  #
  # All content models are queried to see if there are any records available.
  # Content models are determined by checking if the model classes respond
  # #content? as @@true@@.
  # 
  # @example
  #
  #   if Aura.site_empty?
  #     page = Page.new :title => "Hello"
  #     page.save
  #     assert Aura.site_empty? == false
  #   end
  #
  def self.site_empty?
    ! Models.all.select { |m| m.content? }.detect { |m| m.any? }
  end

  # Finds a record that corresponds to a path.
  #
  # @example
  #
  #   products = Page.new :slug => 'products'
  #   products.save
  #
  #   boots = Page.new :parent => 'products', :slug => 'boots'
  #   boots.save
  #
  #   foo = Aura.find('/products/boots')
  #   assert foo == boots
  #
  def self.find(path)
    Slugs.find path
  end

  # Returns all model records without parents.
  # 
  # Records are considered without parents when they respond to #parent
  # with @@nil@@.
  #
  def self.roots
    Models.all.inject([]) { |a, m| a += m.roots.try(:all) }
  end

  # Returns the menu items, sorted properly.
  #
  # @example
  #
  #   -# HAML
  #   - Aura.menu.each do |item|
  #     %li
  #       %a{:href => item.path}= item.menu_title
  #
  def self.menu
    roots.select { |item| item.shown_in_menu? }.sort
  end
end
