require 'active_support/concern'
require 'active_support/callbacks'

module Dynamodel
  extend ActiveSupport::Concern
  include Callbacks

  def initialize(hash={})
    self.class.fields.each do |field|
      self.class.send(:attr_accessor, field)
      send("#{field}=", hash[field])
    end
  end

  def destroy
    db.delete_item(table_name: table_name, key: key_values)
  end

  def save
    run_callbacks :save do
      db.put_item(table_name: table_name, item: attributes)
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

  def key_values
    self.class.keys.inject({}) { |h, k| h.merge!(k => send(k)); h }
  end

  def table_name
    self.class.table_name
  end
end
