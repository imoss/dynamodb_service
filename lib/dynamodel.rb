require 'active_support/concern'
require 'active_support/callbacks'

module Dynamodel
  extend ActiveSupport::Concern
  include Callbacks

  def initialize(hash={})
    self.class.fields.each do |field|
      self.class.send(:attr_accessor, field)
      self.send("#{field}=", hash[field])
    end
  end

  def destroy
    db.delete_item(table_name: self.class.table_name, key: keys)
  end

  def save
    run_callbacks :save do
      db.put_item(table_name: self.class.table_name, item: attributes)
    end
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

  def db
    self.class.db
  end

  def key_names
    self.class.key_schema.map { |k| k[:attribute_name] }
  end

  def keys
    key_names.inject({}) { |h, k| h.merge!(k => send(k)); h }
  end
end
