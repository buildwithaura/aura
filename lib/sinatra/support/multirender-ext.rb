# Allows rendering from multiple engines or renderers.
#
# == Usage
#
#   require 'sinatra/support/multirender'
#
#   class Main < Sinatra::Base
#     register Sinatra::MultiRender
#
#     # These two settings are optional.
#     set :multi_views,   [ './views', './skin/default' ]
#     set :multi_engines, [ :erb, :haml ]
#
#     get '/' do
#       show :home
#     end
#   end
#
# Using #show will automatically find the appropriate template, trying the
# following variations:
#
#   ./views/home.erb
#   ./views/home.haml
#   ./skin/default/home.erb
#   ./skin/default/home.haml
#
module Sinatra::MultiRenderExt
  def self.registered(app)
    views = app.views || './views'

    app.set :multi_engines, Tilt.mappings.keys  unless app.respond_to?(:template_engines)
    app.set :multi_views,   views               unless app.respond_to?(:multi_views)

    app.helpers Helpers
  end

  module Helpers
    # Helper: layout (Helpers)
    # Defines a layout to use.
    def layout(what=nil)
      @layout = what  if what
      @layout
    end

    # Helper: show (Helpers)
    # Shows a given template.
    #
    # ##  Usage
    #     show(template[, options[, locals])
    #     show(model, template[, options[, locals])
    #
    # ## Options
    #   You may pass +options[:engine]+ to specify which engines you will want
    #   to limit the search to. This defaults to +App.multi_engines+, or Tilt's
    #   supported engines if that's not defined.
    #   
    #   You may pass +options[:views]+ to specify which directories to scour.
    #   This defaults to +Main.multi_views+, or +Main.views+.
    #
    # #### Show a template
    #
    #     show :home
    #
    # #### Show a model's view
    # This example looks at `:'page/index'` and `:'base/index'`, using
    # whichever it finds first
    #
    #     page = Page['/about']
    #     show page, :index
    #
    # #### Limiting engines
    #
    #     # HAML only
    #     show :home, engine: :haml
    #
    #     # HAML or ERB, favoring HAML first
    #     show :home, engine: [:haml, :erb]
    #
    # #### Only certain paths
    # Only look at certain paths
    #
    #    show :home, views: [ './views', './skins/default' ]
    #
    def show(templates, *args, &block)
      if templates.respond_to?(:templates_for)
        templates = templates.templates_for(args.shift || 'index')
      end

      options = args.shift || {}
      locals  = args.shift || {}

      paths     = [*(options[:views]  || settings.multi_views)].join(',')
      engines   = [*(options[:engine] || settings.multi_engines)].join(',')

      @layout = options.delete(:layout)

      get_engine = lambda { |template|
        spec = "{#{paths}}/#{template}.{#{engines}}"
        template = Dir[spec].first
        return nil  unless template

        ext      = File.extname(template)[1..-1].to_sym
        options  = settings.send(ext).merge(options)  if settings.respond_to?(ext)

        eng = Tilt[ext]  or raise "Template engine not found: #{ext}"
        [ template, eng ]
      }

      t = @template_cache.fetch templates, options do
        template, engine = [*templates].inject(nil) do |e, t|
          e ||= get_engine[t]
        end

        raise Errno::ENOENT.new(templates.inspect)  unless template

        engine.new(template, 0, options)
      end

      if t
        out = t.render(self, locals, &block)

        if @layout
          layout, @layout = @layout, nil
          out = show(layout, :layout => false) { out }
        end

        out
      end
    end
  end
end

