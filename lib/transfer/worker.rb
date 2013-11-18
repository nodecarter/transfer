class Transfer::Worker
  attr_reader :config


  # Transfer::Worker.new(config)
  # config - instance of Transfer::Config
  def initialize(*args)
    @options = args.extract_options!
    @config = args[0]
  end

  protected

  def table_names
    if config.transfer_all_tables?


    end
  end

  def source_db
    @source_db ||= Sequel.connect(config.source_connection_string)
  end

  def target_db

  end
end
