# This file is here for testing purposes only
require "rubygems"  unless defined?(::Gem)

$RUN = true  if __FILE__ == $0
ENV['APP_ROOT'] ||= File.dirname(__FILE__)

$:.unshift *Dir[File.expand_path('../lib', __FILE__)]

# Gems
require "gemist"
Gemist.setup

require 'aura/app'
