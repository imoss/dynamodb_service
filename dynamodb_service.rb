require 'yaml'

class DynamodbService < Sinatra::Base
  configure do
    env = ENV['RACK_ENV'] || 'development'

    db_configs = YAML.load(File.open(Dir.pwd + '/config/dynamodb.yml'))[env]
    set :db_endpoint, db_configs['endpoint']
    set :db_region, db_configs['region']
  end
end
