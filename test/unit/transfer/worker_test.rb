require File.expand_path '../../../test_helper', __FILE__

TEST_CONFIG = Transfer::Config.new(File.expand_path('config/transfer-test.yml', APP_ROOT))
SOURCE_DB = Sequel.connect(TEST_CONFIG.source)

require 'database_cleaner'
DatabaseCleaner[:sequel, {:connection => SOURCE_DB}]
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
end
