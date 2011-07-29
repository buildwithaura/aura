# Module: Admin (Aura)
# Admin stuff.
#
# ## Description
# This is accessible via {Aura.admin}.
#
class Aura
  module Admin
    extend self

    # Class method: menu (Aura::Admin)
    # Usage: Aura.admin.menu
    #
    # Returns admin menu items.
    #
    def menu
      @menu ||= Menu.new
    end

    # Class method: css (Aura::Admin)
    # Usage: Aura.admin.css
    #
    # Returns the list of CSS files.
    #
    # ## Description
    #    This allows you to customize the admin interface by adding your
    #    own CSS files.
    #
    # #### Example
    # This example adds a CSS file to the admin. This should be in your
    # project's `app/init/`.
    #
    #     [/app/init/admin.rb (rb)]
    #     Aura.admin.css << {:href => '/css/admin-ext.css', :media => 'screen'}
    #
    def css
      @css ||= Array.new([ { :href => '/css/admin.css', :media => 'screen' } ])
    end
  end
end

