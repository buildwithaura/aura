require './lib/aura/version'
Gem::Specification.new do |s|
  s.name = "aura"
  s.version = Aura.version
  s.summary = "Aura CMS."
  s.description = "Aura is a CMS."
  s.authors = ["Rico Sta. Cruz"]
  s.email = ["rico@sinefunc.com"]
  s.homepage = "http://github.com/aura-cms"
  s.files = Dir["*/**/*", "*.md", "Rakefile"].reject { |f| File.directory?(f) }

  s.add_dependency "ffaker", "= 0.4.0"
  s.add_dependency "haml", "= 3.1.1"
  s.add_dependency "jsmin", "= 1.0.1"
  s.add_dependency "rack", "= 1.3.0"
  s.add_dependency "rtopia"
  s.add_dependency "sequel", "= 3.16.0"
  s.add_dependency "shield", "= 0.0.3"
  s.add_dependency "compass", "= 0.11.5"
  s.add_dependency "sinatra", "~> 1.2.6"
  s.add_dependency "sinatra-content-for", "= 0.2"
  s.add_dependency "sinatra-support", "= 1.2.0"
  s.add_dependency "pistol", "= 0.0.2"
  s.add_dependency "shake", "~> 0.1.2"

  s.add_development_dependency "contest", "~> 0.1.3"
  s.add_development_dependency "capybara", "~> 0.4.1.2"
  s.add_development_dependency "rack-test", "~> 0.6.0"
  s.add_development_dependency "sqlite3-ruby", "~> 1.3.3"
end
