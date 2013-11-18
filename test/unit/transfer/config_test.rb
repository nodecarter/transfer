require File.expand_path '../../../test_helper', __FILE__

class Transfer::ConfigTest < MiniTest::Unit::TestCase
  def setup
    @test_config = {
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

  def test_source_hash_default_localhost
    @test_config[:source].delete(:host)
    config = config_from_hash(@test_config)
    assert_equal 'localhost', config.source[:host]
  end

  def test_source_hash_default_encoding
    @test_config[:source].delete(:encoding)
    config = config_from_hash(@test_config)
    assert_equal 'utf-8', config.source[:encoding]
  end

  def config_from_hash(config_hash)
    Transfer::Config.any_instance.stubs(:load_config).returns(config_hash)
    Transfer::Config.new(nil)
  end
end
