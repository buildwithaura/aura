class Aura
  # Class: Menu (Aura)
  # A menu.
  #
  # #### Accessing the singleton
  # Doing Aura.admin.menu will get you the single instance of Aura::Menu.
  #
  #     m = Aura.admin.menu    #=> #<Aura::Menu ...>
  #
  # #### Adding menu items
  # Use {Aura::Menu#add}.
  #
  #     Aura.admin.menu.add "hello",
  #       :name => "Hello",
  #       :href => '/admin/lol',
  #       :icon => 'settings'
  #
  # #### Adding submenu items
  # Add sub items by using the dot notation on the name.
  #
  #     Aura.admin.menu.add "hello.subitem",
  #       :name => "Subitem",
  #       :href => '/admin/lol/sub',
  #       :icon => 'settings'
  #
  # #### Retrieving menu items
  # Use {Aura::Menu.items}.
  #
  #     Aura.admin.menu.items    #=> Array of MenuItems
  #
  #     item = Aura.admin.menu.get('hello')
  #     item.name
  #     item.href
  #     item.icon
  #     item.items    # List of sub items
  #
  class Menu
    # Method: add (Aura::Menu)
    # Adds a menu item.
    #
    # ##  Usage
    #     Aura.admin.menu.add 'key',
    #       :name => 'name',
    #       :href => '/url',
    #       :icon => 'icon_name'     # <= optional
    #
    def add(key, options={})
      path = key.to_s.split('.')
      last = path.pop
      node = root

      path.each do |segment|
        node = (node.raw_items[segment] ||= MenuItem.new)
      end

      node.raw_items[last] = MenuItem.new(options.merge(:path => path, :key => last))
    end

    # Method: items (Aura::Menu)
    # Returns the root menu items.
    #
    # ##  Usage
    #     Aura.admin.menu.items
    #
    # ## Description
    #    Returns instances of {Aura::MenuItem}.
    #
    def items
      root.items
    end

    # Method: get (Aura::Menu)
    # Returns a menu item of a given key.
    #
    # ##  Usage
    #     Aura.admin.menu.get(keyname)
    #
    # ##  Example
    #
    # #### Get and set
    # Use {Aura::Menu#add} to add, then `get` to get.
    #
    #     Aura.admin.menu.add "hello",
    #       :name => "Hello",
    #       :href => '/admin/lol',
    #       :icon => 'settings'
    #
    #     item = Aura.admin.menu.get('hello')  #=> #<MenuItem>
    #     item.name                             #=> "Hello"
    #     item.icon                             #=> "settings"
    #
    def get(key='')
      path = key.to_s.split('.')
      node = root
      path.each { |segment| node = node.raw_items[segment] }
      node
    end

  protected
    def root
      @root ||= MenuItem.new
    end
  end

  # Class: MenuItem (Aura)
  # A menu item.
  #
  # ## Description
  #    This is an OpenStruct.
  #
  #    It will always have `.path` and `.key`.
  #    Optional items are `.name`, `.href`, and `.position`.
  #
  #    Methods such as {Aura::Menu.items} and {Aura::Menu.get} return menu items.
  #
  class MenuItem < OpenStruct
    def initialize(hash={})
      super
      self.items = Hash.new
    end

    def name
      @table[:name] || self.key.capitalize
    end

    def raw_items
      @table[:items]
    end

    def items
      @table[:items].values.sort_by { |item| item.position.to_s || item.key }
    end

    def href
      @table[:href].try(:call) || @table[:href] || R(:admin, *path.split('.'))
    end
  end
end

#Aura.admin.menu.add 'settings.db', :name => "Settings", :href => "/settings"
#Aura.admin.menu.get('settings') # list of MenuItems
#Aura.admin.menu.items
