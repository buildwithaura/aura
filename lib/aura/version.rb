class Aura
  def self.version
    "0.0.1.pre4"
  end
  
  def self.prerelease?
    version.count('.') > 2
  end
end
