class Transfer::Worker
  attr_reader :config

  # Transfer::Worker.new(config)
  # config - instance of Transfer::Config
  def initialize(*args)
    @options = args.extract_options!
    @config = args[0]
  end

  def table_names
    if config.transfer_all_tables?


    end
  end

  def source_db
    @source_db ||= Sequel.connect(config.source)
  end

  def target_db
    @target_db ||= Sequel.connect(config.target)
  end
end
