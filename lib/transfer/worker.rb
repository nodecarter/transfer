class Transfer::Worker
  BUF_SIZE = 1000

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
    target_db.transaction do #(rollback: :always) do
      table_names.each do |table_name|
        transfer_table table_name
      end
    end
  end

  def transfer_table(table_name)
    if target_db.in_transaction?
      actual_transfer_table(table_name)
    else
      target_db.transaction do #(rollback: :always) do
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
    truncate_table_if_needed(table_name)

    logger.info "copy #{table_name}"

    validator = validator(table_name)
    validator.validate_before!(table_name)

    columns, blob_columns = columns_for(table_name)
    copy_data(table_name, columns)
    copy_blobs(table_name, blob_columns)

    validator.validate_after!(table_name)
  end

  def truncate_table_if_needed(table_name)
    return unless config.truncate_tables.include?(table_name)
    logger.info "truncate #{table_name}"
    target_db[table_name].truncate
  end

  def copy_data(table_name, columns)
    target_buf = []
    source_fetch(table_name) do |source_row|
      target_buf << columns.map { |c| source_row[c] }
      if target_buf.length > BUF_SIZE
        target_db[table_name].import(columns, target_buf)
        target_buf.clear
      end
    end

    target_db[table_name].import(columns, target_buf) if target_buf.any?
  end

  def copy_blobs(table_name, blob_columns)
    return unless blob_columns.any?
    logger.info "copy blob columns #{blob_columns}"

    source_model = Sequel::Model(table_name)
    source_model.db = source_db
    pk = source_model.primary_key
    raise "Can't copy blob without primary key or composite primary key" if pk.nil? || pk.is_a?(Array)

    source_fetch(table_name) do |source_row|
      blob_columns.each do |blob_column|
        value = source_row[blob_column]
        next unless value
        blob_value = Sequel.blob(value)
        target_db[table_name].where(pk => source_row[pk]).update(blob_column => blob_value)
      end
    end
  end

  def columns_for(table_name)
    source_columns = source_db[table_name].columns
    target_columns = target_db[table_name].columns
    lost_columns = source_columns - target_columns
    logger.warn "Columns #{lost_columns} not exists in target and will NOT be transfered." if lost_columns.any?
    new_columns = target_columns - source_columns
    logger.warn "Columns #{new_columns} not found in source table." if new_columns.any?
    columns = target_columns - new_columns
    blob_columns = blob_columns_for(table_name) & columns
    [columns - blob_columns, blob_columns]
  end

  def blob_columns_for(table_name)
    target_db.schema(table_name).find_all { |col| col[1][:type] == :blob }.map { |col| col[0] }
  end

  def source_fetch(table_name)
    source_model = Sequel::Model(table_name)
    source_model.db = source_db
    if source_model.primary_key.is_a? Symbol
      source_db[table_name].order(source_model.primary_key).paged_each do |source_row|
        yield source_row
      end
    else
      source_db[table_name].all do |source_row|
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
