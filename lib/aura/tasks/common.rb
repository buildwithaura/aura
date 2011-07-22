class RakeStatus
  def self.heading(what, status)
    if what == :run
      color = 30
      puts "\033[1;#{color}m$ %s \033[0m" % [status]
      return
    end
    puts "* %s" % [status]
  end

  def self.print(what, status)
    color = 32
    color = 31  if what == :error
    what = ""  if what == :info
    puts "\033[1;#{color}m  %-14s\033[0m %s" % [what, status]
  end
end
