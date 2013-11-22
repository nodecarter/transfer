require File.expand_path '../../../test_helper', __FILE__

class Transfer::ConfigTest < MiniTest::Unit::TestCase
  def setup
    @test_config = {
        source: {
            adapter: 'mysql2',
            host: 'localhost',
            database: 'mysql_transfer_test',
            user: 'root',
            password: nil,
            encoding: 'utf8'
        },
        target: {
            adapter: 'postgres',
            host: 'localhost',
            database: 'pg_transfer_test',
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
    config = Transfer::Config.new(@test_config)
    assert_equal 'localhost', config.source[:host]
  end

  def test_source_hash_default_encoding
    @test_config[:source].delete(:encoding)
    config = Transfer::Config.new(@test_config)
    assert_equal 'utf-8', config.source[:encoding]
  end

  def test_target_hash_default_localhost
    @test_config[:target].delete(:host)
    config = Transfer::Config.new(@test_config)
    assert_equal 'localhost', config.target[:host]
  end

  def test_target_hash_default_encoding
    @test_config[:target].delete(:encoding)
    config = Transfer::Config.new(@test_config)
    assert_equal 'utf-8', config.target[:encoding]
  end

  def test_check_source
    @test_config.delete(:source)
    assert_raises Transfer::ConfigError do
      Transfer::Config.new(@test_config)
    end
  end

  def test_check_target
    @test_config.delete(:target)
    assert_raises Transfer::ConfigError do
      Transfer::Config.new(@test_config)
    end
  end

  def test_mode_ok
    modes = %w{ddl data full}
    modes.each do |mode|
      @test_config[:mode] = mode
      config = Transfer::Config.new(@test_config)
      assert config
    end
  end

  def test_mode_error
    modes = %w{mode_x mode_y dll}
    modes.each do |mode|
      @test_config[:mode] = mode
      assert_raises Transfer::ConfigError do
        Transfer::Config.new(@test_config)
      end
    end
  end
end
