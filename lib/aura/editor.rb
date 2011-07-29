# Module: Editor (Aura)
# Editor stuff.
#
# ## Description
# This is accessible via {Aura.editor}.
#
class Aura
  module Editor
    # Class method: roots (Aura::Editor)
    # Returns the root nodes to be shown on the editor sidebar.
    #
    # ## Usage
    #     Aura.editor.roots
    #
    # ## Description
    #    Returns instances of `Sequel::Model` as an array of hashes 
    #    (HashArray).
    #
    def roots
      models = Aura.models.all.select { |m| m.try(:editable?) }

      models.inject(HashArray.new) do |hash, model|
        hash << { model => model.roots }
        hash
      end
    end

    module_function :roots
  end
end
