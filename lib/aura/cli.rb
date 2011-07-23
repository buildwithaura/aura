require 'shake'

class Aura
  class CLI < Shake
    autoload :Helpers, File.expand_path('../cli/helpers', __FILE__)

    include Shake::Defaults
    extend Helpers
  end
end

require File.expand_path('../cli/base', __FILE__)
