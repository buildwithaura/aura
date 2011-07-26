class Aura
  # Class: Menu
  # A menu.
  #
  # ##  Common usage
  #
  #     Aura::Admin.menu
  #     Aura::Admin.menu.add "hello",
  #       :name => "Hello",
  #       :href => '/admin/lol',
  #       :icon => 'settings'
  #
  #     Aura::Admin.menu.add "hello.subitem",
  #       :name => "Subitem",
  #       :href => '/admin/lol/sub',
  #       :icon => 'settings'
  #
  #     Aura::Admin.menu.items
  #
  #     item = Aura::Admin.menu.get('hello')
  #     item.name
  #     item.href
  #     item.icon
  #     item.items    # List of sub items
  #
  class Menu
    def add(key, options={})
      path = key.to_s.split('.')
      last = path.pop
      node = root

      path.each do |segment|
        node = (node.raw_items[segment] ||= MenuItem.new)
      end

      node.raw_items[last] = MenuItem.new(options.merge(:path => path, :key => last))
    end

    def items
      root.items
    end

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

  class MenuItem < OpenStruct
    # This will always have .path, and .key.
    # Optional - .name .href .position

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

#Aura::Admin.menu.add 'settings.db', :name => "Settings", :href => "/settings"
#Aura::Admin.menu.get('settings') # list of MenuItems
#Aura::Admin.menu.items
