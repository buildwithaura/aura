require 'ostruct'

# Class: Subtype (Aura)
# A subtype.
#
# ## Description
#    This is an OpenStruct. See {AuraSubtyped} for details.
#
# ## Allowed options
#
#  * `name`
#  * `template`
#  * `parentable`
#
class Aura
class Subtype < OpenStruct
  def parentable
    r = @table[:parentable]
    r.nil? ? true : r
  end

  alias parentable? parentable

  def to_s
    name
  end

  def name
    @table[:name].to_s
  end

  def template
    @table[:template] || 'show'
  end

  def _id
    # Alias for #id for 1.8.6 compatibility
    @table[:id]
  end
end
end
