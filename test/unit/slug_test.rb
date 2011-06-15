require 'test_helper'

class SlugTest < Test::Unit::TestCase
  setup do
    # With slug
    @products = Page.new :title => 'Products', :slug => 'products'
    @products.save

    # No slug
    @boots = Page.new :title => 'Boots', :parent => @products
    @boots.save
  end

  should "save properly without complaints" do
    assert ! @boots.nil?
    assert ! @products.nil?
  end

  should "autoslug" do
    assert Page[@products.id] == @products
    assert Page[@products.id].slug == 'products'

    assert Page[@boots.id] == @boots
    assert Page[@boots.id].slug == 'boots'

    boots_2 = Page.new :title => 'Boots', :parent => @products
    boots_2.save

    assert_equal 'boots-2', boots_2.slug
  end

  should "find records by their paths" do
    page = Aura.find('/products')
    assert page == @products

    page = Aura.find('/products/boots')
    assert page == @boots
  end
end
