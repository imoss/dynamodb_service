class Comment
  include DynamoDbInteractor

  def self.fields
    [:id, :commenter, :body]
  end

  def self.table
    {
      table_name: "Comments",
      attribute_definitions: [{ attribute_name: "id", attribute_type: "S" }],
      key_schema: [{ attribute_name: "id", key_type: "HASH" }],
      provisioned_throughput: { read_capacity_units: 10, write_capacity_units: 5 }
    }
  end
end
