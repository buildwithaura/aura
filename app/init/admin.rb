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

path   = Main.root_path(%w(public js))
files  = Dir["#{path}/jquery.*.js"]
files += Dir["#{path}/lib.*.js"]
files += Dir["#{path}/admin.js"]
files += Dir["#{path}/admin.*.js"]

Main.set :admin_js, JsFiles.new(files)
