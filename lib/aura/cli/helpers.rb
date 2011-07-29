module Aura::CLI::Helpers
  def color(what, n=32)
    "\033[0;#{n}m#{what}\033[0;m"
  end

  def status(what, message)
    puts "%s  %s" % [ color("%12s" % [what], 32), message ]
  end

  def show_tree(path, what=:create)
    explore = lambda { |*a| #path, depth=0
      path, depth = a
      depth ||= 0

      files = Dir["#{path}/{.*,*}"]

      dirs  = files.select { |f| File.directory?(f) && !%w(. ..).include?(File.basename(f)) }
      files = files.select { |f| File.file?(f) }

      dirname = File.basename(path)
      status :create, path + '/'

      files.each { |f|
        status '', (path + '/' + color(File.basename(f), 30))
      }

      dirs.each  { |d| explore[d, depth+1] }
    }

    explore[path]
  end
end
