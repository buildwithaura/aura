module Sinatra
  module AuraPublic
    def self.registered(app)
      app.extend ClassMethods
    end

    module ClassMethods
      def add_public(dir)
        return  unless File.directory?(dir)
        dir = File.realpath(dir)

        get '*' do |path|
          begin
            fname = File.realpath(File.join(dir, path))
            pass  unless fname[0...dir.size] == dir
            pass  unless File.file?(fname)

            send_file fname
          rescue Errno::ENOENT => e
            pass
          end
        end
      end
    end
  end
end
