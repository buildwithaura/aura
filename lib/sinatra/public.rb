module Sinatra
  module AuraPublic
    def self.registered(app)
      app.extend ClassMethods
    end

    module ClassMethods
      def add_public(dir)
        Dir[File.join(dir, '**/*')].each do |fname|
          path = fname.gsub(/^#{dir}\/*/, '/')
          get(path) { send_file(fname) }
        end
      end
    end
  end
end
