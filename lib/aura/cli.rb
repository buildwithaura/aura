require 'shake'

# Class: CLI (Aura)
# The CLI runner.
#
# ## Description
#    This is a runner based on the [Shake 
#    gem](http://github.com/rstacruz/shake).
#
class Aura
  class CLI < Shake
    autoload :Helpers, File.expand_path('../cli/helpers', __FILE__)

    include Shake::Defaults
    extend Helpers
  end
end

require File.expand_path('../cli/base', __FILE__)
