class Main
  helpers do
    def load_path(path)
      @item = Aura.find(path) or pass
      pass  unless @item.try(:renderable?)

      show @item.page_templates, {}, :item => @item
    end
  end

  get '/*' do |path|
    load_path path
  end

  get '/' do
    path = '/home'

    # Do we have a homepage?
    if Aura.find(path).nil?
      return show(:'default_home_page', :layout => false)
    end

    load_path(path)
  end

  not_found do
    [ 404, show('errors/not_found') ]
  end

  #error 500 do
  #  error 500, show('errors/error')
  #end
end
