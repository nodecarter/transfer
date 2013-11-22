require 'rubygems'
require 'bundler'
Bundler.require(:default)

require 'active_support/core_ext/array'
require 'active_support/core_ext/hash'

APP_ROOT = File.expand_path('../..', __FILE__)

module Transfer
  class ConfigError < StandardError
  end
end

$LOAD_PATH << File.expand_path('..', __FILE__)

require 'transfer/config'
require 'transfer/worker'
