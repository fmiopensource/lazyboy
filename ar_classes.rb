class ARClasses
  # creates dynamic active record classes read from the environment array
  def self.init_classes
    BACKUP_MODELS.each do |name|
      model_name = name.camelize
      Object.const_set(model_name, Class.new(ActiveRecord::Base)).instance_eval {}
    end
  end
end