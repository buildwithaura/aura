class Aura
  # Class method: version (Aura)
  # Returns the current version.
  #
  # ## Example
  #    Aura.version  #=> "0.5.2"
  #
  def self.version
    "0.0.1.pre6"
  end
  
  # Class method: prerelease? (Aura)
  # Checks if the Aura version is a prerelease.
  #
  # ## Example
  #    Aura.version      #=> "0.5.2"
  #    Aura.prerelease?  #=> false
  #
  #    Aura.version      #=> "0.6.0.pre4"
  #    Aura.prerelease?  #=> true
  #
  def self.prerelease?
    version.count('.') > 2
  end
end
