require 'active_support/concern'

module Dynamodel
  extend ActiveSupport::Concern

  def initialize(hash={})
    self.class.fields.each do |field|
      self.class.send(:attr_accessor, field)
      self.send("#{field}=", hash[field])
    end
  end

  def destroy
    self.class.db.delete_item(table_name: self.class.table_name, key: keys)
  end

  def save
    self.class.db.put_item(table_name: self.class.table_name, item: attributes)
  end

  def to_json
    attributes.to_json
  end

  def update_attributes(attributes)
    self.attributes = attributes; save
  end

  private

  def attributes
    self.class.fields.inject({}) { |h, key| h.merge!(key => send(key)); h }
  end

  def attributes=(attributes)
    attributes.each { |k, v| send("#{k}=", v) }
  end

  def key_names
    self.class.key_schema.map { |k| k[:attribute_name] }
  end

  def keys
    key_names.inject({}) { |h, k| h.merge!(k => send(k)); h }
  end

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
