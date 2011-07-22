ENV['RACK_ENV'] = 'test'

require File.expand_path('../app/init.rb', __FILE__)

def require?(what, gem=what)
  require what
rescue LoadError => e
  $stderr << "Oops! Testing needs the #{gem} gem. Please try:\n"
  $stderr << "$ sudo gem install #{gem}\n"
  raise e
end

require? "rack/test", "rack-test"
require? "contest"

class Test::Unit::TestCase
  include Rack::Test::Methods
  include Rtopia

  def setup
    Main.flush!
    Main.seed
  end

  def app
    Main.new
  end

  def p(what, obj=nil)
    return unless ENV['verbose']

    what, obj = nil, what  if obj.nil?
    str = obj.is_a?(String) ? obj : obj.inspect

    file, line = p_source
    basename = File.basename(file)

    if what
      puts "\n\033[1;32m%20s\033[1;30m:%-3s\033[1;30m %s" % [basename, line, what]
      puts "\033[0m%-24s %s" % ['', str]
    else
      puts "\n\033[1;32m%20s\033[1;30m:%-3s\033[0m %s" % [basename, line, str]
    end
  end

  # @return [Array] [ app/test/unit/migration_test.rb, 23 ]
  def p_source
    backtrace[2].split(':')[0..1]
  end

  def backtrace
    raise 1
  rescue => e
    e.backtrace[2..-1]
  end
end

# For testing helpers
class MockSinatra
  def settings; self.class; end
  def self.settings; self; end
  def self.production?; @@production; end
  def self.development?; !@@production; end
  def session; @session ||= Hash.new; end

  def initialize
    @@production = true
  end

  def production(&blk)
    yield self
  end

  def development(&blk)
    @@production = false
    yield self
    @@production = true
  end

  def request
    require 'ostruct'
    return OpenStruct.new(:fullpath => '/', :xhr? => false)
  end
end
