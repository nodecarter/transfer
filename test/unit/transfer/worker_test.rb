require File.expand_path '../../../test_helper', __FILE__

class Transfer::WorkerTest < MiniTest::Unit::TestCase
  def test_table_names
    config = Transfer::Config.new(File.expand_path('config/transfer-test.yml', APP_ROOT))
    worker = Transfer::Worker.new(config)
    source_db = worker.source_db
    source_db.create_table(:test_one) do
      primary_key :id
      String :name
    end
    source_db.create_table(:test_two) do
      primary_key :id
      String :name
    end
    assert_equal %w{test_one test_two}, config.table_names
  end

  # tt = TestTable.new cboolean: true, cdate: Date.today, cdatetime: DateTime.now, cdecimal: 123456.789,
  #   cfloat: 0.0123456789, cinteger: 33000, cstring: 'Я'*255, ctext: 'Ж'*2000, ctime: Time.now, ctimestamp: DateTime.now


  #def setup
  #  #config = Transfer::Config.new(File.expand_path('config/transfer-test.yml', APP_ROOT))
  #  #worker = Transfer::Worker.new(config)
  #  #source_db = worker.source_db
  #  source_cleaner = DatabaseCleaner[:sequel] #, {:connection => source_db}]
  #  source_cleaner.strategy = :truncation
  #  source_cleaner.start
  #end
  #
  #def teardown
  #  #config = Transfer::Config.new(File.expand_path('config/transfer-test.yml', APP_ROOT))
  #  #worker = Transfer::Worker.new(config)
  #  #source_db = worker.source_db
  #  source_cleaner = DatabaseCleaner[:sequel] #, {:connection => source_db}]
  #  #source_cleaner.strategy = :truncation
  #  source_cleaner.clean
  #end
end
