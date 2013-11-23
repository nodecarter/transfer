require File.expand_path '../../../test_helper', __FILE__

TEST_CONFIG = Transfer::Config.new(File.expand_path('config/transfer-test.yml', APP_ROOT))
SOURCE_DB = Sequel.connect(TEST_CONFIG.source)
TARGET_DB = Sequel.connect(TEST_CONFIG.target)

require 'database_cleaner'
DatabaseCleaner[:sequel, {:connection => SOURCE_DB}]
DatabaseCleaner[:sequel, {:connection => TARGET_DB}]
DatabaseCleaner.strategy = :transaction

# tt = TestTable.new cboolean: true, cdate: Date.today, cdatetime: DateTime.now, cdecimal: 123456.789,
#   cfloat: 0.0123456789, cinteger: 33000, cstring: 'Я'*255, ctext: 'Ж'*2000, ctime: Time.now, ctimestamp: DateTime.now

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
    assert_equal true, record[:cdate]
    assert_equal true, record[:cdatetime]
    assert_equal 123456.789, record[:cdecimal]
    assert_equal 0.0123456789, record[:cfloat]
    assert_equal 33000, record[:cinteger]
    assert_equal 'Я'*255, record[:cstring]
    assert_equal 'Ж'*2000, record[:ctext]
    assert_equal true, record[:ctime]
    assert_equal true, record[:ctimestamp]
  end

  def transfer_table(table_name)
    worker = Transfer::Worker.new(TEST_CONFIG, source_db: SOURCE_DB, target_db: TARGET_DB)
    worker.transfer(table_name)
    TARGET_DB[:test_tables]
  end
end
