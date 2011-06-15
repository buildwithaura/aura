class Main
  module FormBuilderHelpers
    def form_builder(name, value=nil, options={})
      partial :'form_builder/builder', :name => name, :value => value
    end
  end

  helpers FormBuilderHelpers
end
