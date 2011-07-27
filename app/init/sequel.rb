Sequel::Model.plugin :aura_model
Sequel::Model.plugin :validation_helpers
Sequel.extension :inflector

class Sequel::Model
  def self.inherited(klass)
    Aura.models.all << klass
    super
  end
end
