require 'rubygems'
require 'bundler/setup'

ENV['RACK_ENV'] ||= 'development'

Bundler.require(:default, ENV['RACK_ENV'].to_sym)

require File.expand_path('../dynamodb_service.rb', __FILE__)
require_all 'lib'
require_all 'models'
require_all 'helpers'
require_all 'controllers'

map('/v1/comments') { run CommentsController }
