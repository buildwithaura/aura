# Models that can be viewed by a URL.
# Supports templating and stuff.
#
# Assumptions:
#
# - Your data table must have `String :template`. (optional;
#   Aura guesses the template name if it's not available.)
#
module Sequel
  module Plugins
    module AuraRenderable
      module InstanceMethods
        # Returns the templates to be tried for the item, listed
        # in order of priority.
        #
        # Example:
        #
        #     [ "product/mofo", "base/mofo", "product/default", "base/default" ]
        #
        def page_templates
          klass = self.class.class_name # blog_post

          [ :"#{klass}/#{template}",
            :"base/#{template}",
            :"#{klass}/show",
            :"base/show"
          ].map { |s| s.to_sym }.uniq
        end

        # Returns the template to be used when it's displayed.
        # Overridden by AuraSubtyped.
        def template
          'show'
        end

        def renderable?
          true
        end
      end
    end
  end
end
