class Main
  get '/:model/list' do |model|
    require_login
    @model = Aura.models.get(model) or pass
    pass unless @model.try(:editable?)

    show_admin @model.templates_for('list'),
      :model => @model
  end

  get '/:model/new' do |model|
    require_login
    @model = Aura.models.get(model) or pass
    pass unless @model.try(:editable?)

    @item = @model.new

    show_admin @model.templates_for('new'),
      :model  => @model,
      :parent => nil,
      :item   => @item,
      :action => @model.path(:new)
  end

  post '/:model/new' do |model|
    require_login
    @model = Aura.models.get(model) or pass
    pass unless @model.try(:editable?)

    begin
      @item = @model.new
      @item.update params[:editor]
      @item.save
      flash_message "The new item has been created."

    rescue Sequel::ValidationFailed
      return show_admin(@model.templates_for('new'),
        :model  => @model,
        :parent => nil,
        :item   => @item,
        :action => @model.path(:new))
    end

    redirect params[:next] || @item.path(:edit)
  end

  get '/*/edit' do |path|
    require_login
    @item = Aura.find(path) or pass
    pass unless @item.try(:editable?)

    show_admin @item.templates_for('edit'),
      :item   => @item,
      :action => @item.path(:edit)
  end

  post '/*/edit' do |path|
    require_login
    @item = Aura.find(path) or pass
    pass unless @item.try(:editable?)

    begin
      @item.set_fields params[:editor]

      unless params[:no_save]
        @item.save
        flash_message "Your edits have been saved."
      end

      return redirect(params[:next])  unless params[:next].nil?

    rescue Sequel::ValidationFailed
    end

    show_admin @item.templates_for('edit'),
      :item   => @item,
      :action => @item.path(:edit)
  end

  get '/*/preview' do |path|
    require_login
    @item = Aura.find(path) or pass
    pass unless @item.try(:editable?)

    show_admin @item.templates_for('preview'),
      :item   => @item
  end

  get '/*/new' do |path|
    require_login
    @parent = Aura.find(path) or pass
    pass unless @parent.try(:parentable?)
    pass unless @parent.try(:editable?)

    @model = @parent.class

    show_admin @model.templates_for('new'),
      :model  => @model,
      :item   => @model.new(:parent => @item),
      :parent => @parent,
      :action => @parent.path(:new)
  end

  post '/*/new' do |path|
    require_login
    @parent = Aura.find(path) or pass
    pass unless @parent.try(:parentable?)
    pass unless @parent.try(:editable?)

    @model = @parent.class

    begin
      @item = @model.new(:parent => @parent)
      @item.update params[:editor]

      raise 1  unless params[:no_save].nil?
      @item.save
      flash_message "The new item has been created."

    rescue => e
      return show_admin(@item.templates_for('new'),
        :model  => @model,
        :item   => @item,
        :parent => @parent,
        :action => @parent.path(:new))
    end

    redirect params[:next] || @item.path(:edit)
  end

  get '/*/delete' do |path|
    require_login
    @item = Aura.find(path) or pass
    pass unless @item.try(:editable?)

    show_admin @item.templates_for('delete'),
      :item   => @item,
      :action => @item.path(:delete)
  end

  post '/*/delete' do |path|
    require_login
    @item = Aura.find(path) or pass
    pass unless @item.try(:editable?)

    action = @item.parent? ? @item.parent.path(:edit) : R(:admin)
    @item.delete
    flash_message "The item has been deleted."

    redirect params[:next] || action
  end
end
