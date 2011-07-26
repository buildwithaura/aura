# Subject to debate.
Dir['{app,core/*,extensions/*}/tasks/**/*.rake'].each { |rb| load rb }

task :default do
  exec 'rake -s -T'
end

desc "Runs tests."
task :test do
  $:.unshift File.join(File.dirname(__FILE__), 'test')

  Dir['{.,extensions/*}/test/**/*_{test,story}.rb'].each do |file|
    next  if ENV['test'] and !file.match(ENV['test'])
    load file unless file =~ /^-/
  end
end

namespace :doc do
  desc "Update documentation."
  task :update do
    # gem proscribe ~> 0.0.2
    system "proscribe build"
  end

  desc "Updates the Aura homepage with the manual."
  task :deploy => :update do
    # http://github.com/rstacruz/git-update-ghpages
    system "git update-ghpages aura-cms/aura-cms.github.com --branch master -i doc/"
  end
end
