class Transfer::Worker
  attr_reader :config

  # Transfer::Worker.new(config)
  # config - instance of Transfer::Config
  def initialize(*args)
    @options = args.extract_options!
    @config = args[0]
  end

  def table_names
    @table_names ||= source_db.tables - config.exclude_tables
  end

  def source_db
    @source_db ||= begin
      db = @options[:source_db] || Sequel.connect(config.source)
      #db.logger = logger
      db
    end
  end

  def target_db
    @target_db ||= begin
      db = @options[:target_db] || Sequel.connect(config.target)
      #db.logger = logger
      db
    end
  end

  def transfer_all
    target_db.transaction(rollback: :always) do
      table_names.each do |table_name|
        transfer_table table_name
      end
    end
  end

  def transfer_table(table_name)
    if target_db.in_transaction?
      actual_transfer_table(table_name)
    else
      target_db.transaction(rollback: :always) do
        actual_transfer_table(table_name)
      end
    end
  end

  def validator(table_name)
    validator_klass = custom_validator(table_name) || Transfer::Validator
    @validators ||= {}
    @validators[validator_klass] ||= validator_klass.new(source_db, target_db)
  end

  def custom_validator(table_name)
    custom_validator_klass = @options["validator-#{table_name}"]
    return nil unless custom_validator_klass.present?
    custom_validator_klass.constantize
  end

  private

  def actual_transfer_table(table_name)
    if config.truncate_tables.include?(table_name)
      logger.info "truncate #{table_name}"
      target_db[table_name].truncate
    end
    logger.info "copy #{table_name}"

    validator = validator(table_name)
    validator.validate_before!(table_name)

    buf_size = 1000
    target_buf = []

    columns = columns_for(table_name)

    source_fetch(table_name) do |source_row|
      target_buf << columns.map { |c| source_row[c] }
      if target_buf.length > buf_size
        target_db[table_name].import(columns, target_buf)
        target_buf.clear
      end
    end
    if target_buf.length > 0
      target_db[table_name].import(columns, target_buf)
    end
    #validator.validate_after!(table_name)
  end

  def columns_for(table_name)
    source_columns = source_db[table_name].columns
    target_columns = target_db[table_name].columns
    lost_columns = source_columns - target_columns
    logger.warn "Columns #{lost_columns} not exists in target and will NOT be transfered." if lost_columns.any?
    new_columns = target_columns - source_columns
    logger.warn "Columns #{new_columns} not found in source table." if new_columns.any?
    target_columns - new_columns
  end

  def source_fetch(table_name)
    source_model = Sequel::Model(table_name)
    source_model.db = source_db
    if source_model.primary_key.is_a? Symbol
      source_db[table_name].order(source_model.primary_key).limit(100).paged_each do |source_row|
        yield source_row
      end
    else
      source_db[table_name].limit(100) do |source_row|
        yield source_row
      end
    end
  end

  def logger
    @logger ||= @options[:logger] || create_default_logger
  end

  def create_default_logger
    logg = Logger.new(STDOUT)
    logg.level = Logger::INFO
    logg
  end
end
