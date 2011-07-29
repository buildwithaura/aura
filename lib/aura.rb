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
# #### Paths
#
#     Aura.root         #=> "~/myapp/root"
#     Aura.gem_root     #=> "/usr/lib/ruby/gems.../aura-0.0.1"
#
# #### Files
#
#     Aura.files['models/book.rb']   #=> "~/myapp/app/models/book.rb"
#     Aura.files.glob('css/**/*')    #=> #<Array>
#
# #### Settings
#
#     Aura.set 'site.name', 'Othello'
#     Aura.get('site.name')          #=> "Othello"
#   
#     # Attempts to set the default site.name, but fails because it was
#     # already set previously.
#     Aura.default 'site.name', 'Talamasca'
#     puts Aura.get('site.name').inspect
#     #=> "Othello"
#
class Aura
  PREFIX = File.dirname(__FILE__)

  # Class method: gem_root (Aura)
  # Usage:        Aura.gem_root([args])
  # Returns the root path of the Aura gem.
  #
  def self.gem_root(*a)
    File.join(ENV['AURA_ROOT'], *a)
  end

  # Class method: root (Aura)
  # Usage:        Aura.root([args])
  # Returns the root path of the application.
  #
  # ## Example
  #     Aura.root              #=> "~/myapp"
  #     Aura.root('init.rb')   #=> "~/myapp/init.rb"
  #
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
  autoload :Public,             gem_root("lib/aura/public")
  autoload :Rendering,          gem_root("lib/aura/rendering")
  autoload :Files,              gem_root("lib/aura/files")
  autoload :Admin,              gem_root("lib/aura/admin")
  autoload :App,                gem_root("app/main")

  require "#{PREFIX}/aura/version"

  # Alias for Setting.get.
  # See Setting.get for an example.
  def self.get(key)
    Setting.get key
  end

  # Alias for Setting.set.
  # See Setting.get for an example.
  def self.set(key, value)
    Setting.set key, value
  end

  # Alias for Setting.default.
  # See Setting.get for an example.
  def self.default(key, value)
    Setting.default key, value
  end

  # Alias for Setting.delete.
  # See Setting.get for an example.
  def self.del(key)
    Setting.del key
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
    db = models.all.first.db

    models.all.inject({}) { |hash, model|
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
    db = models.all.first.db

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
    ! models.all.select { |m| m.content? }.detect { |m| m.any? }
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
    models.all.inject([]) { |a, m| a += m.roots.try(:all) }
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

  # Class method: run_migrations! (Aura)
  # Runs migrations for everything.
  def self.run_migrations!
    Aura.files.glob('migrations/**/*.rb').each { |f| load f }

    # Reload models to ensure they get the right schemae.
    Aura.models.reload!
  end

  # Class method: models (Aura)
  # Returns a list of models.
  #
  # ## Description
  #    This returns a {Aura::Models} instance. See the class
  #    documentation for more info.
  #
  def self.models
    Aura::Models.new
  end

  # Class method: slugs (Aura)
  # Returns the Slugs module.
  #
  # ## Description
  #    Returns {Aura::Slugs} where you can access methods that
  #    deal with URL slugs.
  #
  # ## Example
  #     Aura.slugs.find('/boots')
  #
  def self.slugs
    Slugs
  end

  # Class method: editor (Aura)
  # Usage: Aura.editor
  #
  # Returns the Editor module.
  #
  # ## Description
  #    Returns {Aura::Editor} where you can access methods that
  #    deal with the editor.
  #
  # ## Example
  #     Aura.editor.roots
  #
  def self.editor
    Editor
  end

  # Class method: files (Aura)
  # Usage: Aura.files
  #
  # Returns the Files module.
  #
  # ## Description
  #    Returns {Aura::Files} where you can access methods that
  #    deal with files.
  #
  # ## Example
  #     Aura.files['models/page.rb']
  #
  def self.files
    Files
  end

  # Class method: admin (Aura)
  # Usage: Aura.admin
  #
  # Returns the Admin module.
  #
  # ## Description
  #    Returns {Aura::Admin} where you can access methods that
  #    deal with files.
  #
  # ## Example
  #     Aura.admin.menu
  #
  def self.admin
    Admin
  end
end
