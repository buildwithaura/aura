require 'yaml'
require 'ostruct'

class Aura
  ExtensionNotFound = Class.new(StandardError)

  # Class: Extension (Aura)
  # A class representing an extension in Aura.
  # 
  # #### Lookup
  # Get an Extension instance by passing an extension name.
  #
  #     ext = Aura::Extension['base']
  #
  # #### Loading extensions
  #
  #     ext.active?          #=> false (probably)
  #     ext.load!
  #     ext.active?          #=> true
  #
  # #### Getting extension info
  # These are loaded from an extension's YAML file.
  #
  #     ext.info             #=> #<OStruct>
  #     ext.info.author
  #
  # #### Getting paths
  # Use {Aura::Extension#path}.
  #
  #     ext.path             #=> ~/aura/extensions/base
  #     ext.path('init.rb')  #=> ~/aura/extensions/base/init.rb
  #
  #     Aura::Extension.active  # Active extensions (Array of #<Extension>)
  #     Aura::Extension.all     # All extensions (Array of #<Extension>)
  #
  # #### Manual instanciation
  # You can pass a path to the constructor.
  #
  #     ext = Aura::Extension.new('/path/to/ext')
  #
  class Extension
    attr_reader :name

    # Returns an extension with the given ext name/path.
    # Returns nil if it's not found.
    def self.[](name)
      self.new(name)
    rescue ExtensionNotFound
      nil
    end

    # Returns an extension with the given ext name/path.
    # Raises ExtensionNotFound if it's not found.
    def initialize(name)
      @path, @name = nil

      if File.directory?(name)
        @path, @name = name, File.basename(name)

      elsif Main.respond_to?(:extensions_path)
        @name = name
        [Main.extensions_path].flatten.each do |dir|
          next  unless @path.nil?
          @path = File.join(dir, name)
          @path = nil  unless File.directory?(@path)
        end
      end

      raise ExtensionNotFound  unless File.directory?(@path.to_s)
    end

    # Method: path (Aura::Extension)
    # Returns the path of the extension.
    #
    # ## Description
    #    If arguments are given, they are joined into the extension's path.
    #    nil will be returned if the path does not exist.
    #
    # ## Example
    #
    #     Aura::Extension['base'].path             #=> ~/aura/extensions/base
    #     Aura::Extension['base'].path('init.rb')  #=> ~/aura/extensions/base/init.rb
    #
    def path(*a)
      return @path  if a.empty?
      ret = File.join(@path, *(a.map { |arg| arg.to_s }))
      ret = File.expand_path(ret) # Try to fix some heroku issues (?)
      File.exists?(ret) ? ret : nil
    end

    # Method: load! (Aura::Extension)
    # Loads an extension.
    #
    def load!
      # TODO Don't load a module that's already loaded

      # Load the main file
      fname = path("#{name}.rb")
      require fname  unless fname.nil?

      # Load the basic things usually autoloaded.
      Dir["#{@path}/{init,models,routes,helpers}/*.rb"].each { |f| require f }

      # Ensure public/ works
      public_path = path(:public)
      Main.add_public(public_path)  unless public_path.nil?

      # Add the view path, if it has
      if path(:views)
        paths = [path(:views)]
        paths += Main.multi_views  if Main.respond_to?(:multi_views)
        Main.set :multi_views, paths
      end
    end

    # Method: active? (Aura::Extension)
    # Determines if the given extension is currently active in the config.
    #
    def active?
      self.class.active_names.include?(@name)
    end

    # Initializes an extension after it's already loaded.
    # This is done after all extensions are loaded.
    #
    def init
      fname = path("init.rb")
      load fname  unless fname.nil?
    end

    # Method: info (Aura::Extension)
    # Returns an OpenStruct of information on the extension.
    #
    # ##  Example
    #
    #     Aura::Extension['default_theme'].info
    #     Aura::Extension['default_theme'].info.author
    #
    def info
      return @info  unless @info.nil?

      fname = path('info.yml')
      return nil  if fname.nil?

      @info ||= OpenStruct.new(YAML::load_file(fname).merge({:path => @path}))
    end

    alias to_s name

    # Class method: active (Aura::Extension)
    # Returns all the extensions that are loaded in the config.
    #
    # ## See also
    #  * {Aura::Extension.all}
    #
    def self.active
      self.active_names.map { |ext| self[ext] }.compact
    end

    # Class method: active_names (Aura::Extension)
    # Returns all names of the extensions that are loaded in the config.
    #
    # ## Description
    #    Returns an array of strings.
    #
    def self.active_names
      exts  = Array.new
      exts += Main.additional_extensions  if Main.respond_to?(:additional_extensions)
      exts
    end

    # Class method: all (Aura::Extension)
    # Returns all extensions (not just the ones loaded).
    #
    # ## Description
    #    Returns an array of {Aura::Extension} instances.
    #
    # ## See also
    #  * {Aura::Extension.active}
    #
    def self.all
      return @all  unless @all.nil?

      paths = Main.extensions_path.map { |path| Dir["#{path}/*"] }.flatten

      @all ||= paths.uniq.map { |path| self.new(path) }.compact
    end
  end
end
