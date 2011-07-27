class Aura
  module Editor
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
