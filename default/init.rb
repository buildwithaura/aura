ENV['APP_FILE'] = __FILE__

# Gems
require "rubygems"  unless defined?(::Gem)
require "bundler"
Bundler.setup

require 'aura/app'
