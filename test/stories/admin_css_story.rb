require File.expand_path('../../stories_helper', __FILE__)

class AdminCssStory < Story
  test "x" do
    login!

    assert page.body.include?("<link href='/css/admin.css' media='screen' rel='stylesheet' type='text/css'")
  end

  test "add" do
    Aura.admin.css << {:href => '/css/admin-ext.css'}

    login!

    assert page.body.include?("<link href='/css/admin-ext.css' media='screen' rel='stylesheet' type='text/css'")
    assert page.body =~ /admin\.css.*admin-ext.css/m
  end
end
