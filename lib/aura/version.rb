class Aura
  def self.version
    "0.0.1.pre3"
  end
  
  def self.prerelease?
    version.count('.') > 2
  end
end
