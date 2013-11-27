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

    validator = validator(table_name)
    validator.validate_before!(table_name)
    source_model = Sequel::Model(table_name)
    source_model.db = source_db

    #binding.pry
    #rows_per_fetch = 100
    #if source_db[:table_name]
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
end
