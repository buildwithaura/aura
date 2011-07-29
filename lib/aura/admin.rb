# Module: Admin (Aura)
# Admin stuff.
#
# ## Description
# This is accessible via {Aura.admin}.
#
class Aura
  module Admin
    # Class method: menu (Aura)
    # Returns admin menu items.
    #
    def self.menu
      @menu ||= Menu.new
    end
  end
end

