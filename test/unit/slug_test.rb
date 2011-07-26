require File.expand_path('../../test_helper', __FILE__)

class SlugTest < Test::Unit::TestCase
  setup do
    # With slug
    @products = Aura::Models::Page.new :title => 'Products', :slug => 'products'
    @products.save

    # No slug
    @boots = Aura::Models::Page.new :title => 'Boots', :parent => @products
    @boots.save
  end

  should "save properly without complaints" do
    assert ! @boots.nil?
    assert ! @products.nil?
  end

  should "autoslug" do
    assert Aura::Models::Page[@products.id] == @products
    assert Aura::Models::Page[@products.id].slug == 'products'

    assert Aura::Models::Page[@boots.id] == @boots
    assert Aura::Models::Page[@boots.id].slug == 'boots'

    boots_2 = Aura::Models::Page.new :title => 'Boots', :parent => @products
    boots_2.save

    assert_equal 'boots-2', boots_2.slug
  end

  should "find records by their paths" do
    page = Aura.find('/products')
    assert page.id == @products.id

    page = Aura.find('/products/boots')
    assert page.id == @boots.id
  end
end
