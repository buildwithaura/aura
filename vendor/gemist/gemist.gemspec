require "./lib/gemist"
Gem::Specification.new do |s|
  s.name = "gemist"
  s.version = Gemist.version
  s.summary = "An extremely minimal solution to gem isolation"
  s.description = "Gemist leverages on purely Rubygems to require the correct gem versions in a project."
  s.authors = ["Rico Sta. Cruz"]
  s.email = ["rico@sinefunc.com"]
  s.homepage = "http://github.com/rstacruz/gemist"
  s.files = Dir["{lib,test}/**/*", "*.md", "Rakefile"].reject { |f| File.directory?(f) }
end

# gem build *.gemspec
# gem push *.gem
