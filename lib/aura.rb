ENV['AURA_ROOT'] ||= File.expand_path('../../', __FILE__)

if ENV['APP_FILE']
  ENV['APP_ROOT'] ||= File.dirname(ENV['APP_FILE'])
else
  ENV['APP_ROOT'] ||= ENV['AURA_ROOT']
  ENV['APP_FILE'] ||= __FILE__
end

require "sequel"

# Class: Aura
# The main class.
#
class Aura
  PREFIX = File.dirname(__FILE__)

  def self.gem_root(*a)
    File.join(ENV['AURA_ROOT'], *a)
  end

  def self.root(*a)
    File.join(ENV['APP_ROOT'], *a)
  end

  autoload :Extension,          gem_root("lib/aura/extension")
  autoload :ExtensionNotFound,  gem_root("lib/aura/extension")
  autoload :CLI,                gem_root("lib/aura/cli")
  autoload :Menu,               gem_root("lib/aura/menu")
  autoload :Models,             gem_root("lib/aura/models")
  autoload :Slugs,              gem_root("lib/aura/slugs")
  autoload :Subtype,            gem_root("lib/aura/subtype")
  autoload :Seeder,             gem_root("lib/aura/seeder")
  autoload :Utils,              gem_root("lib/aura/utils")
  autoload :Editor,             gem_root("lib/aura/editor")
  autoload :App,                gem_root("app/main")

  require "#{PREFIX}/aura/version"

  Model = Sequel::Model

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

  # Class method: db_dump (Aura)
  # Returns the database backup as a hash.
  #
  # @see db_dump_yaml
  #
  # ## Example
  #
  #     data = Aura.db_dump
  #     yml_data = YAML::dump(data) # also see db_dump_yaml.
  #     File.open('backup.yml', 'w') { |f| f << yml_data }
  #     puts yml_data.inspect
  #
  #     # Sample output:
  #     # pages:
  #     #     - title: Hello.
  #     #       body: Good day everyone!
  #     #     - title: Cheers!
  #     #       body: What's going on?
  #     # settings:
  #     #     - ...
  #
  def self.db_dump
    db = Models.all.first.db

    Models.all.inject({}) { |hash, model|
      table = model.table_name
      hash[table] = db[table].all
      hash
    }
  end

  # Class method: db_restore (Aura)
  # Restores a previous output of db_dump.
  #
  # This function takes in the parameter `hash`, which is a hash table
  # with the keys as the table names, and it's values are arrays of
  # records.
  # 
  # See #db_dump for an example of the hash that #db_restore expects.
  #
  # ## Example
  #
  #     # Load a previously saved copy of the hash, as spitted out
  #     # by db_dump.
  #     yaml_data = YAML::load_file 'backup.yml'
  #
  #     # Load it.
  #     Aura.db_restore(yaml_data)
  #
  def self.db_restore(hash)
    # Hash format:
    # { :table_name => [ array of hashes of rows ], ... }

    # Bring the DB back to the state where we have tables ready.
    Main.flush!
    Aura.run_migrations!
    db = Models.all.first.db

    hash.each do |table, entries|
      entries.each do |entry|
        db[table] << entry
      end
    end
  end

  # Class method: db_dump_yaml (Aura)
  # Returns the database backup as a YAML document.
  #
  def self.db_dump_yaml
    require 'yaml'
    YAML::dump db_dump
  end

  # Class method: site_empty? (Aura)
  # Checks if the site is empty.
  #
  # All content models are queried to see if there are any records available.
  # Content models are determined by checking if the model classes respond
  # #content? as `true`.
  # 
  # ## Example
  #
  #     if Aura.site_empty?
  #       page = Page.new :title => "Hello"
  #       page.save
  #       assert Aura.site_empty? == false
  #     end
  #
  def self.site_empty?
    ! Models.all.select { |m| m.content? }.detect { |m| m.any? }
  end

  # Class method: find (Aura)
  # Finds a record that corresponds to a path.
  #
  # ## Example
  #
  #     products = Page.new :slug => 'products'
  #     products.save
  #
  #     boots = Page.new :parent => 'products', :slug => 'boots'
  #     boots.save
  #
  #     foo = Aura.find('/products/boots')
  #     assert foo == boots
  #
  def self.find(path)
    Slugs.find path
  end

  # Class method: roots (Aura)
  # Returns all model records without parents.
  # 
  # Records are considered without parents when they respond to #parent
  # with `nil`.
  #
  def self.roots
    Models.all.inject([]) { |a, m| a += m.roots.try(:all) }
  end

  # Class method: menu (Aura)
  # Returns the menu items, sorted properly.
  #
  # ##  Example
  #
  #       - Aura.menu.each do |item|
  #         %li
  #           %a{:href => item.path}= item.menu_title
  #
  def self.menu
    roots.select { |item| item.shown_in_menu? }.sort
  end

  # Class method: admin_menu (Aura)
  # Returns admin menu items.
  #
  def self.admin_menu
    @menu ||= Menu.new
  end

  # Class method: run_migrations! (Aura)
  # Runs manual migrations for everything.
  def self.run_migrations!
    files  = Array.new
    files << gem_root('app/migrations/**/*.rb')
    files << root('app/migrations/**/*.rb')
    files += Extension.active.map { |e| e.path('migrations/**/*.rb') }

    # Find and load all
    files = files.compact.map { |spec| Dir[spec].sort }.flatten.uniq
    files.each { |f| load f }

    # Reload models to ensure they get the right schemae.
    Aura::Models.reload!
  end
end
