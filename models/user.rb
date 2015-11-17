class User
  include Dynamodel::Document

  table "Users", read_capacity: 10, write_capacity: 5

  key :id, key_type: "HASH", attribute_type: "S"
  field :name

  def self.generate_identifier
    SecureRandom.uuid
  end

  def before_save
    self.id ||= self.class.generate_identifier
  end
end
