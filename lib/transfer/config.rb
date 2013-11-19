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

  def target
    {
        host: 'localhost',
        encoding: 'utf-8'
    }.merge(config[:target])
  end

  def check_config!
    %w{source target mode}.each do |required_key|
      assert_config config.has_key?(required_key.to_sym),
                    "'#{required_key}' not found in configuration."
    end

    allowed_modes = %w{ddl data full}
    assert_config allowed_modes.include?(config[:mode]),
                  "unknown 'mode' in configuration. allowed modes are #{allowed_modes}"
  end

  def transfer_all_tables?
    true
  end

  def mode
    config[:mode].to_sym
  end

  private

  def assert_config(assertion, message)
    raise Transfer::ConfigError.new(message) unless assertion
  end

  def load_config(config_filename)
    YAML::load(config_filename)
  end
end
