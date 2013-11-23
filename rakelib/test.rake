namespace :db do
  task :prepare => [:drop, :create, :restore]

  desc 'create test databases'
  task :create => [:environment] do
    with_source_connection do |client, database|
      query = "CREATE DATABASE IF NOT EXISTS #{client.escape(database)} CHARACTER SET utf8 COLLATE utf8_unicode_ci"
      puts "creating source test database #{database}..."
      client.query(query)
    end
    with_target_connection do |conn, database|
      query = "CREATE DATABASE #{conn.escape_string(database)} ENCODING 'utf8'"
      puts "creating target test database #{database}..."
      conn.exec(query)
    end
  end

  desc 'drop test source database'
  task :drop => [:environment] do
    with_source_connection do |client, database|
      puts "dropping source test database #{database}..."
      query = "DROP DATABASE IF EXISTS #{client.escape(database)}"
      client.query(query)
    end
    with_target_connection do |conn, database|
      puts "dropping target test database #{database}..."
      query = "DROP DATABASE IF EXISTS #{conn.escape_string(database)}"
      conn.query(query)
    end
  end

  desc 'restore test source database from dump'
  task :restore => [:create] do
    config = get_test_config
    source = config.source
    dump_file = File.expand_path('test/fixtures/test_source_dump.sql', APP_ROOT)
    recovery_cmd = "mysql -u #{source[:username]} -h #{source[:host]} -D #{source[:database]} < #{dump_file}"
    puts "restore source test database: '#{recovery_cmd}'"
    system recovery_cmd
  end

  # connect to database server to manipulate with a database
  def with_source_connection
    config = get_test_config
    conn_hash = config.source.dup
    database = conn_hash.delete(:database)
    client = Mysql2::Client.new(conn_hash)
    begin
      yield client, database
    ensure
      client.close
    end
  end

  # connect to database server to manipulate with a database
  def with_target_connection
    config = get_test_config
    conn_hash = config.target.dup
    database = conn_hash.delete(:database)
    client = PG::Connection.new(host: conn_hash[:host], user: conn_hash[:username])
    begin
      yield client, database
    ensure
      client.close
    end
  end

  def get_test_config
    Transfer::Config.new(File.expand_path('config/transfer-test.yml', APP_ROOT))
  end
end


desc 'run tests'
task :test => ['db:prepare'] do
  Dir.glob('test/**/*_test.rb').each do |test_file|
    ruby test_file
  end
end
