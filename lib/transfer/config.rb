require 'yaml'

class Transfer::Config
  attr_reader :config

  def initialize(config_source)
    plain_hash = config_source.is_a?(Hash) ? config_source : load_config(config_source)
    @config = HashWithIndifferentAccess.new(plain_hash).deep_symbolize_keys
    #@config = plain_hash.deep_symbolize_keys
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
    assert_config config && config.is_a?(Hash), 'configuration does not loaded'

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

  def exclude
    (config[:exclude] || []).map { |table_name| table_name.to_sym }
  end

  private

  def assert_config(assertion, message)
    raise Transfer::ConfigError.new(message) unless assertion
  end

  def load_config(config_filename)
    File.open(config_filename, 'r') do |config_file|
      YAML.load(config_file)
    end
  end
end
