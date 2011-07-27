class Aura
  module Slugs
    extend self

    # @group Module functions

    # Finds a record from a path.
    #
    # Please use {Aura.find}.
    #
    def find(path)
      item = find_by_model_id(path)
      return item  unless item.nil?

      path = path.split('/').reject { |s| s.empty? }
      item = nil

      path.each do |slug|
        item = find_single(slug, item)
        return nil  if item.nil?
      end

      item
    end

    # Finds a record from a model id path in the format */model_name/id*.
    #
    # You do not need to call this as this is already done by
    # {Aura.find}.
    #
    # @example
    #
    #   page = Aura::Slugs.find_by_model_id('/page/2')
    #   assert page == Page[2]
    #
    def find_by_model_id(path)
      model_name, id = path.squeeze('/').split('/').compact
      return nil  if id.nil?

      # Make sure it's numeric
      id = id.to_i
      return nil  if id == 0

      model = Aura.models.all.detect { |m| m.class_name == model_name }
      return nil  if model.nil?

      model[id]
    end

    # Ensures that a given model is going to be searched by
    # {Aura.find}.
    #
    # This is automatically called by {Sequel::Plugins::AuraSluggable}.
    #
    # @example
    #
    #   # Loading the sluggable plugin does {#register} automatically.
    #   class MyModel < Aura::Model
    #     plugin :aura_sluggable
    #   end
    #
    #   item = MyModel.new :slug => 'hello'
    #   item.save
    #
    #   # Now you may search for it.
    #   assert item == Aura.find('/hello')
    #
    def register(model)
      @models ||= []
      @models << model  unless @models.include? model
    end

  protected
    def find_single(slug, parent=nil)
      models.each do |model|
        item = model.get_by_slug(slug, parent)
        return item  unless item.nil?
      end
      nil
    end

    def models
      @models ||= []
    end
  end
end

