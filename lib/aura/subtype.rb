require 'ostruct'

# Class: Subtype (Aura)
# A subtype.
#
# ## Description
#    This is an OpenStruct. See {AuraSubtyped} for details.
#
class Aura
class Subtype < OpenStruct
  def to_s
    name
  end

  def name
    @table[:name].to_s
  end

  def template
    @table[:template] || 'id'
  end

  def _id
    # Alias for #id for 1.8.6 compatibility
    @table[:id]
  end
end
end
