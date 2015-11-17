module Dynamodel
  module ClassMethods
    @@attribute_definitions = []
    @@fields = []
    @@keys = []
    @@key_schema = []

    # TODO: find a way to use attr_reader for getters

    def attribute_definitions
      @@attribute_definitions
    end

    def read_capacity
      @@read_capacity
    end

    def write_capacity
      @@write_capacity
    end

    def table_name
      @@table_name
    end

    def fields
      @@fields
    end

    def keys
      @@keys
    end

    def key_schema
      @@key_schema
    end

    def create(attributes={})
      db.put_item(table_name: table_name, item: attributes)
    end

    def create_table
      db.create_table(table_attributes)
    end

    def db
      Aws::DynamoDB::Client.new(
        endpoint: DynamodbService.settings.db_endpoint,
        region: DynamodbService.settings.db_region
      )
    end

    def delete_table
      db.delete_table(table_name: table_name)
    end

    def field(name)
      @@fields << name
    end

    def find(keys)
      resp = db.get_item(table_name: table_name, key: keys)
      new(resp.item.with_indifferent_access) if resp.item
    end

    def key(name, args={})
      @@fields << name
      @@keys << name
      @@attribute_definitions << { attribute_name: name, attribute_type: args[:attribute_type] }
      @@key_schema << { attribute_name: name, key_type: args[:key_type] }
    end

    def table(name, args={})
      @@table_name ||= name
      @@read_capacity ||= args[:read_capacity]
      @@write_capacity ||= args[:write_capacity]
    end

    def table_attributes
      {
        table_name: table_name,
        attribute_definitions: attribute_definitions,
        key_schema: key_schema,
        provisioned_throughput: {
          read_capacity_units: read_capacity,
          write_capacity_units: write_capacity
        }
      }
    end
  end
end
