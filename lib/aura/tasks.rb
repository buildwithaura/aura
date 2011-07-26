# Module: Tasks (Aura)
# Rake tasks loader.
#
# #### Loading Rake tasks
# Put {Aura::Tasks.load!} in your project's `Rakefile`.
#
#     # [Rakefile (ruby)]
#     require 'aura'
#     Aura::Tasks.load!
#
class Aura
  module Tasks
    # Class method: load! (Aura::Tasks)
    # Loads rake tasks.
    #
    # ## Description
    #    Put this in your app's Rakefile. See {Aura::Tasks} for an example.
    #
    def self.load!
      require File.expand_path('../tasks/common.rb', __FILE__)
      load    File.expand_path('../tasks/db.rake', __FILE__)
    end
  end
end
