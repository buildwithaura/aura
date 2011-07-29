ENV['APP_FILE'] = __FILE__

# Gems
require "rubygems"  unless defined?(::Gem)

begin
  require "bundler"
  Bundler.setup
rescue LoadError => e
  $stderr << "\nYou will need Bundler to run this application. Try:\n"
  $stderr << "$ gem install bundler\n\n"
  exit
end

require "aura/app"
