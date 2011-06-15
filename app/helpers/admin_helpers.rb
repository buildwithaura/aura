class Main
  module AdminHelpers
    # Renders an admin page with the admin template.
    # 
    def show_admin(template, locals={})
      show template, { :layout => :'admin/layout' }, locals
    end

    def area_class(str=nil)
      @area_class = str  unless str.nil?
      @area_class
    end

    def admin_css
      [{ :href => '/css/admin.css', :media => 'screen' }]
    end

    # Draws an <img> tag of the given icon.
    def admin_icon(icon)
      icon = "#{icon}.png"  unless icon.to_s.include?('.')
      tag(:img, nil, { :src => "/images/admin_icons/#{icon}", :class => 'icon' })
    end

    # Renders a 'back to dashboard' link in the sidebar.
    # Example:
    #
    #   - content_for :nav do
    #     != admin_back_to_dashboard
    #     %nav
    #       %ul
    #         ...
    #
    def admin_back_to_dashboard
      partial :'admin/_back_to_dashboard'
    end
  end

  helpers AdminHelpers
end
