class Aura
  # Admin menu
  #
  # == Common usage
  #
  #   Aura::Admin.menu
  #   Aura::Admin.menu.add "hello", :name => "Hello"
  #
  # See Admin::Menu for more info.
  #
  module Admin
    extend self
    def menu
      @menu ||= Menu.new
    end
  end
end
