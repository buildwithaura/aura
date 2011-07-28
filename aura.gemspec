require './lib/aura/version'
Gem::Specification.new do |s|
  s.name = "aura"
  s.version = Aura.version
  s.summary = "Aura CMS."
  s.description = "Aura is a CMS."
  s.authors = ["Rico Sta. Cruz"]
  s.email = ["rico@sinefunc.com"]
  s.homepage = "http://aura-cms.github.com"
  s.files = `git ls-files`.strip.split("\n")

  s.add_dependency "ffaker", "= 0.4.0"
  s.add_dependency "haml", "= 3.1.1"
  s.add_dependency "jsmin", "= 1.0.1"
  s.add_dependency "rack", "= 1.3.0"
  s.add_dependency "rtopia"                         # Helpers
  s.add_dependency "sequel", "= 3.16.0"             # ORM
  s.add_dependency "shield", "= 0.0.3"              # User authentication
  s.add_dependency "compass", "= 0.11.5"
  s.add_dependency "sinatra", "~> 1.2.6"
  s.add_dependency "sinatra-content-for", "= 0.2"
  s.add_dependency "sinatra-support", "= 1.2.0"
  s.add_dependency "sinatra-sequel", "~> 0.9.0"
  s.add_dependency "rake", "~> 0.9.2"
  s.add_dependency "nokogiri", "~> 1.5.0"           # HTML parser
  s.add_dependency "pistol", "= 0.0.2"              # Rack reloader
  s.add_dependency "shake", "~> 0.1.2"              # CLI helpers
  s.add_dependency "rdiscount", "~> 1.6.8"          # Markdown support
  s.add_dependency "RedCloth", "~> 4.2.7"           # Textile support

  s.add_development_dependency "capybara", "~> 0.4.1.2"
  s.add_development_dependency "rack-test", "~> 0.6.0"
  s.add_development_dependency "sqlite3-ruby", "~> 1.3.3"
  s.add_development_dependency "launchy", "~> 0.3.7"
  s.add_development_dependency "para", "~> 0.0.4"
  # s.add_development_dependency "contest", "~> 0.1.3"
end
