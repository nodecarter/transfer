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
end
