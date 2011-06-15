require 'ostruct'

# Gem environment manager.
module Gemist
  VERSION = "0.1.0"

  def self.version
    VERSION
  end

  # Loads the gems via +require+.
  def self.require(env=ENV['RACK_ENV'])
    load_rubygems
    setup env
    gemfile.gems_for(env).each { |g| g.require! }
  end

  # Loads the gems for a given environment.
  def self.setup(env=ENV['RACK_ENV'])
    @fail = Array.new

    gemfile.gems_for(env).each do |g|
      g.load! or @fail << g
    end

    if @fail.any?
      commands = @fail.map { |g| g.to_command }.compact
      list     = commands.map { |cmd| "gem install #{cmd}" }

      if list.any?
        $stderr << "Some gems failed to load. Try:\n\n"
        $stderr << "#{list.join("\n")}\n\n"
      end

      print_errors_for(@fail)
      exit 256
    end
  end

  # Returns the Gemfile for the current project.
  def self.gemfile
    @@gemfile ||= Gemfile.load
  end

private
  # Prints errors for failed gems
  def self.print_errors_for(gems)
    # Remove those
    gems = gems.reject { |g| g.error.name == g.name }

    if gems.any?
      $stderr << "These errors occured:\n"
      gems.each { |gem| $stderr << "  [#{gem.name}] #{gem.error.to_s}\n" }
    end
  end

  # Loads rubygems. Skips if it's not needed (like in Ruby 1.9)
  def self.load_rubygems
    Kernel.require 'rubygems'  unless Object.const_defined?(:Gem)
  end
end

# A definition of a project Gemfile manifest.
class Gemist::Gemfile
  # Returns the path of the project's Gemfile manifest, or +nil+ if
  # not available.
  def self.path
    %w(GEMFILE BUNDLER_GEMFILE).each do |spec|
      return ENV[spec]  if ENV[spec] && File.exists?(ENV[spec])
    end

    Dir["./{Gemistfile,Gemfile,Isolate}"].first
  end

  def self.lockfile_path
    Dir["#{path}.lock"].first
  end

  # Checks if the project has a Gemfile manifest.
  def self.exists?
    !!path
  end

  # Returns a Gemfile instance made from the project's manifest.
  def self.load
    new(File.read(path), lockfile_contents)  if exists?
  end

  def initialize(contents, lockfile)
    instance_eval contents

    # Parse the lockfile
    if lockfile
      lockfile.split("\n").each { |s|
        name, version = s.scan(/^    ([^ ]+) \(([0-9].*?)\)$/).first
        gem = self[name]
        gem.versions = [version]  if gem
      }
    end
  end

  # Returns a gem
  def [](name)
    gems.select { |gem| gem.name == name }.first
  end

  # The list of gems the Gemfile. Returns an array of Gem instances.
  def gems()
    @gems ||= Array.new
  end

  # Returns a list of Gem instances for the given environment.
  def gems_for(env)
    gems.select { |g| g.group == nil || g.group.include?(env.to_s.to_sym) }
  end

protected
  def self.lockfile_contents
    File.read(lockfile_path)  if lockfile_path
  end

  # (DSL) Adds a gem.
  #
  # == Example
  #
  #   # Gemfile
  #   gem "sinatra"
  #   gem "sinatra", "1.1"
  #   gem "sinatra", "1.1", :require => "sinatra/base"
  #
  def gem(name, *args)
    options = args.last.is_a?(Hash) ? args.pop : Hash.new

    options[:name]    ||= name
    options[:version] ||= args
    options[:group]   ||= @group

    gem = self[name]

    if gem
      gem.update options
    else
      self.gems << Gemist::Gem.new(options)
    end
  end

  # (DSL) Defines a group.
  #
  # == Example
  #
  #   # Gemfile
  #   group :test do
  #     gem "capybara"
  #   end
  #
  def group(*names, &blk)
    @group = names.map { |s| s.to_sym }
    yield
    @group = nil
  end

  # Does nothing. Here for Bundler compatibility.
  def source(src)
  end
end

# A Gem in the gemfile.
class Gemist::Gem
  attr_accessor :name
  attr_accessor :versions
  attr_accessor :require
  attr_accessor :group
  attr_reader :error

  def initialize(options={})
    update options
  end

  def update(options={})
    self.name       = options[:name]     unless options[:name].nil?
    self.versions   = options[:version]  unless options[:version].nil?
    self.group      = options[:group]    unless options[:group].nil?
    self.require    = options[:require]  unless options[:require].nil?
    self.require    = self.name  if self.require.nil?
  end

  # Activates the gem; returns +false+ if it's not available.
  def load!
    ::Gem.activate name, *versions
    true
  rescue ::Gem::LoadError => e
    @error = e
    false
  end

  # Loads the gem via +require+. Make sure you load! it first.
  # Returns true if loaded.
  def require!
    [*require].each { |r| Kernel.require r  if r }
  end

  # Returns the +gem install+ paramaters needed to install the gem.
  def to_command
    if error
      [error.name, *version_join(error.requirement.to_s.split(', '))].join(' ')  if error.name
    else
      [name, version_join(versions)].compact.join ' '
    end
  end

private
  def version_join(vers)
    versions = [*vers].sort.map { |v| "-v #{v.to_s.inspect}"  unless v.to_s == '>= 0' }.compact
    versions.join(' ')  unless versions.empty?
  end
end
