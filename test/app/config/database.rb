Main.configure do |m|
  file = Tempfile.new('a')
  m.set :sequel, "sqlite://#{file.path}"
end
