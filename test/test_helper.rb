require 'rubygems'
require 'bundler'
Bundler.require(:default, :test)
require 'minitest/autorun'
require 'mocha/setup'
require 'minitest/reporters'
MiniTest::Reporters.use!

require File.expand_path '../../lib/transfer', __FILE__

class MiniTest::Unit::TestCase
  def config_from_hash(config_hash)
    Transfer::Config.any_instance.stubs(:load_config).returns(config_hash)
    Transfer::Config.new(nil)
  end

  def sample_config_hash
    {
        source: {
            adapter: 'mysql2',
            host: 'localhost',
            database: 'mysql_source',
            user: 'root',
            password: nil,
            encoding: 'utf8'
        },
        target: {
            adapter: 'postgres',
            host: 'localhost',
            database: 'pg_target',
            user: 'postgres',
            password: nil,
            encoding: 'utf8'
        },
        worker: {
            stop_on_error: true
        },
        mode: 'full'
    }
  end

  def sample_config
    config_from_hash(sample_config_hash)
  end
end
