ENV['AURA_ROOT'] ||= File.expand_path('../../../', __FILE__)

if ENV['APP_FILE']
  ENV['APP_ROOT'] ||= File.dirname(ENV['APP_FILE'])
else
  ENV['APP_ROOT'] ||= ENV['AURA_ROOT']
  ENV['APP_FILE'] ||= __FILE__
end

root = lambda { |p=''| File.expand_path("#{p}", ENV['AURA_ROOT']) }

require "sinatra/base"
require "sinatra/support"
require "rtopia"
require "sequel"
require "sinatra/content_for"
require "sinatra/sequel"
require "pistol"
require "json"
require "yaml"
require "shield"
require "ostruct"
require "fileutils"

# Helpers
require root['lib/core/hasharray']
require root['lib/core/object_ext']

# Aura proper
require root['lib/aura']

# Terra
require root['lib/terra']
require root['lib/terra/ext']

# Sinatra plugins
require root['lib/sinatra/public']
require root['lib/sinatra/support/multirender-ext']

# Sequel plugins
Dir[root['lib/sequel/plugins/*.rb']].each { |f| require f }

if defined?(::Encoding)
  Encoding.default_external = 'utf-8'
end

class Main < Sinatra::Base
  set      :root, lambda { |*args| File.join(ENV['AURA_ROOT'], *args) }
  set      :root_path, lambda { |*args| root *args }
  set      :approot, lambda { |*args| File.join(ENV['APP_ROOT'] || root, *args) }

  set      :haml, :escape_html => true
  set      :haml, :escape_html => true, :ugly => true  if production?

  enable   :raise_errors

  use      Rack::Session::Cookie
  use      Rack::Deflater  if production?

  register Sinatra::AuraPublic
  register Sinatra::MultiRenderExt
  register Sinatra::CompassSupport
  register Aura::Seeder
  register Sinatra::SequelExtension

  helpers  Rtopia
  helpers  Sinatra::ContentFor
  helpers  Sinatra::UserAgentHelpers
  helpers  Shield::Helpers

  # Load all, but load defaults first
  ( Dir[root('config/*.rb')].sort +
    Dir[approot('config/*.rb')].sort
  ).uniq.each { |f| load f }

  set :login_success_message, nil

  set :multi_views,     [root('app/views')]
  set :app_files,       Dir[root('init.rb'), root('{app,extensions}/**/*.rb') + root('**/*.rb')]
  set :extensions_path, [root('extensions'), approot('extensions')]

  # Heroku - override the DB config with this env var.
  set :database_url, ENV['DATABASE_URL']  unless ENV['DATABASE_URL'].nil?

  def self.restart!
    require 'fileutils'
    FileUtils.touch approot('tmp', 'restart.txt')
  end

  # Connect to db
  database
end

# Initializers
require root['app/init/pistol.rb']
require root['app/init/admin.rb']
require root['app/init/sequel.rb']

# Bootstrap Aura
Dir[root['app/{models,helpers,routes}/**/*.rb']].each { |f| require f }

# Extensions
require root['app/init/extensions.rb']

# Load app/
if File.directory?(Main.approot('app'))
  Aura::Extension.new(Main.approot('app')).load!
end

Main.set :port, ENV['PORT'].to_i  unless ENV['PORT'].nil?
Main.run!  if ENV['APP_FILE'] == $0
