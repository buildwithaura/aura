class Aura
  module Tasks
    # Loads rake tasks.
    #
    # Put this in your app's Rakefile.
    #
    def self.load!
      require File.expand_path('../tasks/common.rb', __FILE__)
      load    File.expand_path('../tasks/db.rake', __FILE__)
    end
  end
end
