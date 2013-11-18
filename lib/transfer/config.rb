class Transfer::Config
  attr_reader :config

  def initialize(config_filename)
    @config = load_config(config_filename)
    check_config!
  end

  def source
    {
        host: 'localhost',
        encoding: 'utf-8'
    }.merge(config[:source])
  end

  def check_config!

  end

  def transfer_all_tables?
    true
  end

  private

  def load_config(config_filename)
    YAML::load(config_filename)
  end
end
