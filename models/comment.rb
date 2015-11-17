class Comment
  include Dynamodel::Document

  table "Comments", read_capacity: 10, write_capacity: 5

  key :id, key_type: "HASH", attribute_type: "S"
  field :commenter
  field :body

  def self.generate_identifier
    SecureRandom.uuid
  end

  def before_save
    self.id ||= self.class.generate_identifier
  end
end
