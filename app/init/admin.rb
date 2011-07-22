Aura::Admin.menu.tap { |m|
  m.add "settings",
    :name => "Settings",
    :href => Rtopia.R(:admin, :settings),
    :icon => 'settings'

  m.add "settings.database",
    :name => "Database",
    :href => Rtopia.R(:admin, :settings, :database)

  m.add "settings.your_account",
    :name => "Your account",
    :href => Rtopia.R(:user, :me, :edit)
  
  m.add "settings.users",
    :name => "Users",
    :href => Rtopia.R(:user, :list)
}

Main.register Sinatra::CompressedJS

path = Main.root_path(%w(public js))

Main.serve_compressed_js :admin_js,
  :prefix => '/js',
  :root   => path,
  :path   => '/admin/script.js',
  :files  =>
    Dir["#{path}/jquery.*.js"].sort +
    Dir["#{path}/lib.*.js"].sort +
    Dir["#{path}/admin.js"].sort +
    Dir["#{path}/admin.*.js"].sort

 
