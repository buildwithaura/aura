ENV['AURA_ROOT'] ||= File.expand_path('../../../', __FILE__)

if ENV['APP_FILE']
  ENV['APP_ROOT'] ||= File.dirname(ENV['APP_FILE'])
else
  ENV['APP_ROOT'] ||= ENV['AURA_ROOT']
  ENV['APP_FILE'] ||= __FILE__
end

root = lambda { |p=''| File.expand_path("#{p}", ENV['AURA_ROOT']) }

# TODO: Get rid of this after removing jsfiles
$:.unshift *Dir[root['vendor/*/lib']]

require "sinatra/base"
require "sinatra/support"
require "rtopia"
require "sequel"
require "sinatra/content_for"
require "jsfiles"
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
  helpers  Rtopia

  use      Rack::Deflater  if production?

  # Load all, but load defaults first
  ( Dir[root('config/*.rb')].sort +
    Dir[approot('config/*.rb')].sort
  ).uniq.each { |f| load f }

  register Sinatra::AuraPublic
  register Sinatra::MultiRenderExt
  register Sinatra::CompassSupport
  register Aura::Seeder
  helpers  Sinatra::ContentFor
  helpers  Sinatra::UserAgentHelpers
  helpers  Shield::Helpers

  set :login_success_message, nil

  set :multi_views,     [root('app/views')]
  set :app_files,       Dir[root('init.rb'), root('{app,core}/**/*.rb') + root('extensions/**/*.rb')]
  set :extensions_path, [root('core'), approot('extensions')]

  # Heroku: override the DB config with this env var.
  set :sequel, ENV['DATABASE_URL']  unless ENV['DATABASE_URL'].nil?

  unless self.respond_to?(:sequel)
    $stderr << "No database configured. Try `rake setup` first.\n"
    exit
  end

  set :db, Sequel.connect(sequel)

  def self.restart!
    require 'fileutils'
    FileUtils.touch approot('tmp', 'restart.txt')
  end
end

# Initializers
require root['app/init/pistol.rb']
require root['app/init/admin.rb']
require root['app/init/sequel.rb']

# Bootstrap Aura
Dir[root['app/{models,helpers,routes}/**/*.rb']].each { |f| require f }

# Extensions
require root['app/init/extensions.rb']

Main.set :port, ENV['PORT'].to_i  unless ENV['PORT'].nil?
Main.run!  if ENV['APP_FILE'] == $0
