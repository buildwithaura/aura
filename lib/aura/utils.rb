class Aura
  module Utils
    extend self

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

    def key_value(k, v)
      require 'cgi'
      '%s=%s' % [CGI.escape(k.to_s), URI.escape(v.to_s)]
    end

    def underscorize(klass)
      klass.to_s.split('::').last.scan(/[A-Z][a-z0-9]*/).map { |s| s.downcase }.join('_')
    end
  end
end
