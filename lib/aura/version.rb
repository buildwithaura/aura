class Aura
  def self.version
    "0.0.1.pre2"
  end
  
  def self.prerelease?
    version.count('.') > 2
  end
end
