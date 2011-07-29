# Module: Utils (Aura)
# Miscellaneous utilities.
#
class Aura
  module Utils
    extend self

    # Method: query_string (Aura::Utils)
    # Converts a hash into a query string.
    #
    # ## Usage
    #     query_string(hash)
    #
    # ## Example
    #     query_string(:q => "peanuts", :page => 2)
    #     #=> q=peanuts&page=2
    #
    #     query_string(:fruits => %w[apple banana])
    #     #=> q[]=apple&q[]=banana
    #
    def query_string(hash)
      hash.inject([]) { |arr, (key, value)|
        if value.is_a?(Array)
          value.each do |e|
            arr << key_value("#{key}[]", e)
          end
          arr
        elsif value.is_a?(Hash)
          value.each do |namespace, deeper|
            arr << key_value("#{key}[#{namespace}]", deeper)
          end
          arr
        else
          arr << key_value(key, value)
        end
      }.join('&')
    end

    # Method: key_value (Aura::Utils)
    # Converts two strings into a key value pair.
    #
    # ## Example
    #     key_value('q', 'peanuts')
    #     #=> q=peanuts
    #
    def key_value(k, v)
      require 'cgi'
      '%s=%s' % [CGI.escape(k.to_s), URI.escape(v.to_s)]
    end

    # Method: underscorize (Aura::Utils)
    # Underscorizes a class's name.
    #
    # ## Example
    #     underscorize(Sequel::Plugins::AuraSluggable)
    #     #=> 'aura_sluggable'
    #
    def underscorize(klass)
      klass.to_s.split('::').last.scan(/[A-Z][a-z0-9]*/).map { |s| s.downcase }.join('_')
    end

    # Method: in_dir? (Aura::Utils)
    # Usage:  Utils.in_dir?(file, dir)
    #
    # Checks if a given `file` is inside `dir`.
    #
    def in_dir?(file, dir)
      return false  unless File.exists?(file)

      dir  = File.realdirpath(dir) # Can throw Errno:ENOENT
      node = File.dirname(file)

      while true
        parent = File.realdirpath(File.join(node, '..'))
        return false  if parent == node
        return true   if node == dir
        node = parent
      end
    end
  end
end
