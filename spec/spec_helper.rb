ENV['RACK_ENV'] = 'test'
Bundler.require(:default, ENV['RACK_ENV'].to_sym)

require File.expand_path('../../dynamodb_service.rb', __FILE__)
require_all 'lib'
require_all 'models'
require_all 'helpers'
require_all 'controllers'

RSpec.configure do |config|
  config.include Rack::Test::Methods
  config.color = true
end

def app
  @app ||= described_class
end
