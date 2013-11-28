class Transfer::Worker
  attr_reader :config

  # Transfer::Worker.new(config)
  # config - instance of Transfer::Config
  def initialize(*args)
    @options = args.extract_options!
    @config = args[0]
  end

  def table_names
    @table_names ||= source_db.tables
  end

  def source_db
    @source_db ||= @options[:source_db] || Sequel.connect(config.source)
  end

  def target_db
    @target_db ||= @options[:target_db] || Sequel.connect(config.target)
  end

  def transfer_all
    target_db.transaction do
      table_names.each do |table_name|
        transfer_table table_name
      end
    end
  end

  def transfer_table(table_name)
    # checks before:
    #   source:
    #     - table exists
    #   target:
    #     - table exists
    #     - table empty
    # checks after:
    #   target:
    #     - records count the same as in source
    #     - next autoincrement value

    log "transfer table #{table_name}"
    validator = validator(table_name)
    validator.validate_before!(table_name)
    source_model = Sequel::Model(table_name)
    source_model.db = source_db
    source_db[table_name].order(source_model.primary_key).paged_each do |source_row|
      target_db[table_name].insert(source_row)
    end
    validator.validate_after!(table_name)
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

  def logger
    @logger ||= @options[:logger] || create_default_logger
  end

  def create_default_logger
    logg = Logger.new(STDOUT)
    logg.level = Logger::INFO
    logg
  end

  def log(message)
    logger.info message
  end
end
