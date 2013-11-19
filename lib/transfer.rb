#require 'active_support/core_ext/object/blank'

module Transfer
  class ConfigError < StandardError
  end
end

$LOAD_PATH << File.expand_path('..', __FILE__)

require 'transfer/config'
require 'transfer/worker'
