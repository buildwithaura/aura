class Main
  module AdminHelpers
    # Admin helper: show_admin (Helpers)
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

    # Admin helper: admin_icon (Helpers)
    # Draws an img tag of the given icon.
    #
    # ##  Example
    #
    #     != admin_icon('add')
    #     #=> <img src='/images/admin_icons/add.png' class='icon'>
    #
    def admin_icon(icon)
      icon = "#{icon}.png"  unless icon.to_s.include?('.')
      tag(:img, nil, { :src => "/images/admin_icons/#{icon}", :class => 'icon' })
    end

    # Admin helper: admin_back_to_dashboard (Helpers)
    # Renders a 'back to dashboard' link in the sidebar.
    #
    # ##  Example
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
