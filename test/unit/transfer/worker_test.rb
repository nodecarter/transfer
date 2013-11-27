# encoding: utf-8

require File.expand_path '../../../test_helper', __FILE__

TEST_CONFIG = Transfer::Config.new(File.expand_path('config/transfer-test.yml', APP_ROOT))
SOURCE_DB = Sequel.connect(TEST_CONFIG.source)
TARGET_DB = Sequel.connect(TEST_CONFIG.target)

require 'database_cleaner'
DatabaseCleaner[:sequel, {:connection => SOURCE_DB}]
DatabaseCleaner[:sequel, {:connection => TARGET_DB}]
DatabaseCleaner.strategy = :transaction

class Transfer::WorkerTest < MiniTest::Unit::TestCase
  def setup
    DatabaseCleaner.start
  end

  def teardown
    DatabaseCleaner.clean
  end

  def test_table_names
    worker = Transfer::Worker.new(TEST_CONFIG, source_db: SOURCE_DB)
    assert_equal [:test_child_tables, :test_tables], worker.table_names.sort
  end

  def test_transfer_all_records
    target_table = transfer_table(:test_tables)
    assert_equal 3, target_table.count
  end

  def test_transfer_all_fields
    target_table = transfer_table(:test_tables)
    record = target_table.first
    assert record
    assert_equal true, record[:cboolean]
    assert_equal Date.new(2013,11,20), record[:cdate]
    assert_equal DateTime.new(2013,11,20,8,19,44,'+4'), record[:cdatetime]
    assert_equal '0.123456E6', record[:cdecimal].to_s
    assert_equal '0.0123457', record[:cfloat].to_s
    assert_equal 33000, record[:cinteger]
    assert_equal 'Я'*255, record[:cstring]
    assert_equal 'Ж'*2000, record[:ctext]
    tm = Time.new Date.today.year, Date.today.month, Date.today.day, 8, 19, 44, '+04:00'
    assert_equal tm, record[:ctime]
    assert_equal Time.new(2013,11,20,8,19,44,'+04:00'), record[:ctimestamp]
  end

  def transfer_table(table_name)
    worker = Transfer::Worker.new(TEST_CONFIG, source_db: SOURCE_DB, target_db: TARGET_DB)
    worker.transfer_table(table_name)
    TARGET_DB[:test_tables]
  end
end
