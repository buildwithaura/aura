Main.configure do |m|
  m.set :database_url, "sqlite://db/development.db"
end

Main.configure(:test) do |m|
  path = "#{Dir.tmpdir}/test-#{rand}.db"

  m.set :migrations_log, lambda { StringIO.new }
  m.set :database_url, "sqlite://#{path}"

  at_exit { FileUtils.rm_rf path }
end
