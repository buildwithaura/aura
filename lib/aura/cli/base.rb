class Aura::CLI
  # TODO This looks stupid, refactor later
  task :new do
    require 'fileutils'
    require 'aura/version'

    if params.empty?
      err "Usage: #{$0} new PROJECT_NAME"
      pass
    end

    name = params.first
    path = File.join(ENV['AURA_ROOT'], 'default')

    if File.exists?(name)
      err "That path already exists."
      pass
    end

    FileUtils.mkdir name

    # Copy everything over
    Dir["#{path}/**/{.*,*}"].sort.each do |from|
      base   = from.gsub(path, '')
      fn     = File.basename(from)
      target = File.join(name, base)

      next if ['Gemfile.lock', '.rvmrc'].include?(fn)

      if File.file?(from)
        FileUtils.mkdir_p File.dirname(target)
        FileUtils.cp from, target
      end
    end

    # Edit the Gemfile
    gemfile = File.read(File.join(name, 'Gemfile'))
    version = Aura.prerelease? ? Aura.version : "~> #{Aura.version}"
    gemfile.gsub!("AURA_GEM_VERSION", version)

    File.open(File.join(name, 'Gemfile'), 'w') { |f| f.write gemfile }

    show_tree name

    puts ""
    puts "Done! Get started now:"
    puts ""
    puts "  $ cd #{name}"
    puts "  $ bundle install"
    puts ""
    puts "Then start it as a Rack app."
    puts ""
    puts "  $ rackup"
    puts ""
  end

  task.description = "Starts a new project"
  task.usage = "new NAME"

  task :help do
    err "Usage: #{executable} <command>"
    err
    err "Options:"
    err "  -v, [--version]      Shows the Aura version number and quits"
    err
    err "Commands:"
    tasks.each { |name, task| err "  %-20s %s" % [ name, task.description ] }
    err
    err "Description:"
    err "  The '#{executable} new' command creates a new Aura application with"
    err "  the default directory structure."
    err
    err "Example:"
    err "  # This generates a new project in ./my_project."
    err "  $ aura new my_project"
    err
  end
  task.description = "Shows this help screen"

  def self.run(*a)
    if %w(-v --version).include?(a.join(' '))
      require 'aura/version'

      puts "Aura #{Aura.version}"
      exit
    end

    super *a
  end
end
