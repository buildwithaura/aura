# Sequel plugin: AuraEditable
# For things that you can edit in the admin panel.
#
# ## Description
#    Use this plugin in you want your model editable.
#
# #### How to use
# Use `plugin :aura_editable`.
#
#     module Aura::Models
#       class Book < Model
#         plugin :aura_editable
#       end
#     end
#
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
