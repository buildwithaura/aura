require 'yaml'
require 'ostruct'

class Aura
  ExtensionNotFound = Class.new(StandardError)

  # Aura extensions.
  #
  # == Common usage
  #
  #   ext = Aura::Extension['base']
  #
  #   ext.active?
  #   ext.load!
  #
  #   ext.info             #=> #<OStruct>
  #   ext.info.author
  #
  #   ext.path             #=> ~/aura/core/base
  #   ext.path('init.rb')  #=> ~/aura/core/base/init.rb
  #
  #   Aura::Extension.active  # Active extensions (Array of #<Extension>)
  #   Aura::Extension.all     # All extensions (Array of #<Extension>)
  #
  # == Not-so-common
  #
  #   ext = Aura::Extension.new('/path/to/ext')
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

    # Returns the path of the extension.
    # If arguments are given, they are joined into the extension's path.
    # nil will be returned if the path does not exist.
    #
    # Example:
    #
    #   Aura::Extension['base'].path             #=> ~/aura/core/base
    #   Aura::Extension['base'].path('init.rb')  #=> ~/aura/core/base/init.rb
    #
    def path(*a)
      return @path  if a.empty?
      ret = File.join(@path, *(a.map { |arg| arg.to_s }))
      ret = File.expand_path(ret) # Try to fix some heroku issues (?)
      File.exists?(ret) ? ret : nil
    end

    # Loads an extension.
    def load!
      # TODO: Don't load a module that's already loaded

      # Load the main file
      fname = path("#{name}.rb")
      require fname  unless fname.nil?

      # Load the basic things usually autoloaded.
      Dir["#{@path}/{models,routes,helpers}/*.rb"].each { |f| require f }

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

    # Determines if the given extension is currently active in the config.
    def active?
      self.class.active_names.include?(@name)
    end

    # Initializes an extension after it's already loaded.
    # This is done after all extensions are loaded.
    def init
      fname = path("init.rb")
      load fname  unless fname.nil?
    end

    # Returns an ostruct of information on the extension.
    # Example:
    #
    #   Aura::Extension['default_theme'].info
    #   Aura::Extension['default_theme'].info.author
    def info
      return @info  unless @info.nil?

      fname = path('info.yml')
      return nil  if fname.nil?

      @info ||= OpenStruct.new(YAML::load_file(fname).merge({:path => @path}))
    end

    alias to_s name

    # Returns all the extensions that are loaded in the config.
    def self.active
      return @actives  unless @actives.nil?
      @actives ||= self.active_names.map { |ext| self[ext] }.compact
    end

    # Returns all names of the extensions that are loaded in the config.
    def self.active_names
      exts  = Array.new
      exts += Main.core_extensions        if Main.respond_to?(:core_extensions)
      exts += Main.additional_extensions  if Main.respond_to?(:additional_extensions)
      exts
    end

    # Returns all extensions (not just the ones loaded).
    def self.all
      return @all  unless @all.nil?
      @all ||= Dir[Main.root_path('{core,extensions}/{base,*}')].uniq.map { |path| self.new(path) }.compact
    end
  end
end
