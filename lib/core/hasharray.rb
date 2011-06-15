# A stopgap solution to Ruby 1.8's lack of ordered hashes.
#
# A HashArray, for all intents and purposes, acts like an array. However, the
# common stuff are overloaded to work with hashes.
#
# == Basic usage
#
# You can create a HashArray by passing it an array:
#
#   dict = HashArray.new([
#     { :good_morning => "Bonjour" },
#     { :goodbye      => "Au revoir" },
#     { :good_evening => "Bon nuit" }
#   ])
#
# You may also use it like so:
#
#   letters = [ { :a => "Aye"}, { :b => "Bee" } ].to_hash_array
#
# Now you can use the typical enumerator functions:
#
#   dict.each do |(key, value)|
#     puts "#{key} is #{value}"
#   end
#
#   #=> :good_morning is "Bonjour"
#   #   :goodbye is "Au revoir"
#   #   :good_evening is "Bon nuit"
#
class HashArray < Array
  # Works like Hash#each.
  #
  # By extension, methods that rely on #each (like #inject) will work
  # as intended.
  #
  def each(&block)
    super { |hash| yield hash.to_a.flatten }
  end

  # Works like Hash#map.
  def map(&block)
    super { |hash| yield hash.to_a.flatten }
  end

  # Works like Hash#values.
  def values
    inject([]) { |a, (k, v)| a << v; a }
  end

  # Returns everything as a hash.
  def to_hash
    inject({}) { |hash, (k, v)| hash[k] = v; hash }
  end
end

class Array
  # Transforms a given array of hashes into a HashArray.
  def to_hash_array
    HashArray.new self
  end
end
