module DynamoDbInteractor
  module ClassMethods
    def create(attributes)
      db.put_item(table_name: table_name, item: attributes)
    end

    def find(keys)
      resp = db.get_item(table_name: table_name, key: keys)
      new(resp.item.with_indifferent_access) if resp.item
    end

    def create_table
      db.create_table(table)
    end

    def delete_table
      db.delete_table(table_name: table_name)
    end

    def db
      Aws::DynamoDB::Client.new(
        endpoint: DynamodbService.settings.db_endpoint,
        region: DynamodbService.settings.db_region
      )
    end

    def key_schema
      table[:key_schema]
    end

    def table_name
      table[:table_name]
    end
  end
end
