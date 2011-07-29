class Main
  helpers do
    def render_from_app(fname, type, types=[])
      exts = ([type] + types).join(',')

      fn = Aura.files.glob("#{type}/#{fname}.{#{exts}}").first or return

      extension = File.extname(fn)[1..-1].to_sym  # :sass
      if extension == type
        send_file fn
      else
        content_type type
        render extension, File.read(fn)
      end
    end

    # Try to #show something
    def render_from_view(what, type, engines=[:sass])
      out = show :"#{type}/#{what}", :engine => engines

      content_type type
      out
    rescue Errno::ENOENT => e
      nil
    end
  end

  get '/css/*.css' do |fname|
    engines = %w(sass scss less)
    type    = :css

    x   = render_from_app( fname, type, engines)
    x ||= render_from_view(fname, type, engines)
    x || pass
  end

  get '/js/*.js' do |fname|
    engines = %w(coffee)
    type    = :js

    x   = render_from_app( fname, type, engines)
    x ||= render_from_view(fname, type, engines)
    x || pass
  end
end
