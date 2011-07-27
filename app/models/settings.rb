class Setting < Sequel::Model
  plugin :serialization, :yaml, :value

  def self.seed(type=nil, &blk)
    super
    Aura.default :'site.name', "My Site"
  end

  # Returns the value of a certain key.
  #
  # The get, set, default and delete methods are accessible from the
  # Aura class.
  #
  # @example
  #
  #   Aura.set 'site.name', 'Othello'
  #   puts Aura.get('site.name').inspect
  #   #=> "Othello"
  #
  #   # Attempts to set the default site.name, but fails because it was
  #   # already set previously.
  #   Aura.default 'site.name', 'Talamasca'
  #   puts Aura.get('site.name').inspect
  #   #=> "Othello"
  #
  #   Aura.delete 'site.name'
  #
  def self.get(key)
    find(:key => key.to_s).try(:value)
  end

  # Deletes a key.
  # See get for an example.
  def self.del(key)
    s = find(:key => key.to_s)
    return  if s.nil?

    value = s.value
    s.delete
    value
  end

  # Sets the value of a key.
  # See get for an example.
  def self.set(key, value)
    s = find(:key => key.to_s) || new
    s.key   = key
    s.value = value
    s.save
    value
  end

  # Sets the default value of a key.
  # See get for an example.
  def self.default(key, value)
    s = find(:key => key.to_s)
    return set(key, value)  if s.nil?
    get key
  end
end
