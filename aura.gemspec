Gem::Specification.new do |s|
  s.name = "aura"
  s.version = "0.0.1"
  s.summary = "Aura CMS."
  s.description = "Aura is a CMS."
  s.authors = ["Rico Sta. Cruz"]
  s.email = ["rico@sinefunc.com"]
  s.homepage = "http://github.com/aura-cms"
  s.files = Dir["*/**/*", "*.md", "Rakefile"].reject { |f| File.directory?(f) }

  # TODO: migrate gemfile here
  # s.add_dependency "nest", "~> 1.0"
end
