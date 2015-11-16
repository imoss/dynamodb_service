class Comment
  include Dynamodel

  table "Comments", read_capacity: 10, write_capacity: 5

  key :id, key_type: "HASH", attribute_type: "S"
  field :commenter
  field :body
end
