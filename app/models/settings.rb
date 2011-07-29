# Model: Setting
# A setting.
#
# ## Description
# You don't need to use this model directly. Just use:
#
#  * {Aura.set}
#  * {Aura.get}
#
class Setting < Sequel::Model
  plugin :serialization, :yaml, :value

  def self.seed(type=nil, &blk)
    super
    Aura.default :'site.name', "My Site"
  end

  # Class method: get (Setting)
  # Returns the value of a certain key.
  #
  # The get, set, default and delete methods are accessible from the
  # Aura class.
  #
  def self.get(key)
    find(:key => key.to_s).try(:value)
  end

  # Class method: del (Setting)
  # Deletes a key.
  #
  def self.del(key)
    s = find(:key => key.to_s)
    return  if s.nil?

    value = s.value
    s.delete
    value
  end

  # Class method: set (Setting)
  # Sets the value of a key.
  #
  def self.set(key, value)
    s = find(:key => key.to_s) || new
    s.key   = key
    s.value = value
    s.save
    value
  end

  # Class method: default (Setting)
  # Sets the default value of a key.
  #
  def self.default(key, value)
    s = find(:key => key.to_s)
    return set(key, value)  if s.nil?
    get key
  end
end
