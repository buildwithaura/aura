# Sinatra plugin: Public (Aura)
# Allows apps to use more than one public folder.
#
# ## Description
#    This is used by the {Main} application.
#    This is a general-purpose plugin that can be used in other Sinatra
#    projects.
#
# ##  Usage
#     class MyApp < Sinatra::Base
#       register Aura::Public
#
#       add_public path
#       add_public path[, :prefix => PREFIX]
#     end
#
# ##  Example
#
# #### Add a public dir
# Just pass a path to `add_public`.
#
#     class MyApp < Sinatra::Base
#       add_public "#{root}/app/public"
#     end
#
# #### Accessing
# This may be used to access `app/public/script.js`.
#
#     $ curl http://localhost:4567/script.js
#
# #### Prefix
# Here's how you add a prefix.
#
#      add_public "#{root}/js", :prefix => "javascripts/"
#      $ curl http://localhost:4567/javascripts/app.js
#
class Aura
  module Public
    def self.registered(app)
      app.extend ClassMethods
    end

    module ClassMethods
      # Class method: add_public (Aura::Public)
      # Adds a new public dir.
      #
      # ## Description
      # See {Aura::Public} for usage and examples.
      #
      def add_public(dir, options={})
        return  unless File.directory?(dir)
        dir = File.realpath(dir)

        prefix = options.delete(:prefix)

        get "#{prefix}*" do |path|
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
