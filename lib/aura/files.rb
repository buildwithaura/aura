# Module: Files (Aura)
# Files stuff.
#
# ## Description
# This is accessible via {Aura.files}.
#
class Aura
  module Files
    def self.[](fname)
      try = lambda { |f| f if File.exists?(f) }

      re   = try[Aura.gem_root("app/#{fname}")]
      Extension.active.each { |e| re ||= try["#{e.path}/#{fname}"] }
      re ||= try[Aura.root("app/#{fname}")]
    end

    def self.glob(spec)
      paths = Array.new
      paths << Aura.gem_root("app/#{spec}")
      paths += Extension.active.map { |e| "#{e.path}/#{spec}" }
      paths << Aura.root("app/#{spec}")

      paths.compact.map { |spec| Dir[spec].sort }.flatten.uniq
    end
  end
end
