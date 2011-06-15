module Sequel
  module Plugins
    module AuraEditable
      module InstanceMethods
        def editable?
          true
        end
      end

      module ClassMethods
        def editable?
          true
        end

        def form(type=:edit, &block)
          @forms ||= Hash.new
          return @forms[type]  unless block_given?

          @forms[type] = ::Terra::Form.new
          @forms[type].configure &block
        end
      end
    end
  end
end
