Main.configure do |m|
  m.set :database_url, "sqlite://db/development.db"
end

Main.configure(:test) do |m|
  m.set :database_url, "sqlite://#{Dir.tmpdir}/test-#{Time.now.to_i}.db"
end
