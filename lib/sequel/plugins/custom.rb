module Sequel
module Plugins
module AuraCustom
  module InstanceMethods
    def custom
      @values[:custom]
    end

    def custom=(hash)
      @values[:custom] ||= Hash.new
      @values[:custom] = @values[:custom].merge(hash)
    end
  end
end
end
end
