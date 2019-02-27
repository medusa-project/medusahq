require 'test_helper'

class ConfigurationTest < ActiveSupport::TestCase

  def setup
    raw_config_struct = File.read(File.join(Rails.root, 'config', 'application.yml'))
    @config_struct = YAML.load(raw_config_struct)[Rails.env]
    @config = Configuration.instance
  end

  # get()

  test 'get() with a bogus config key returns nil' do
    assert_nil @config.get(:bogus)
  end

  test 'get() with a valid config key returns the value' do
    assert_equal @config_struct[:medusa_url], @config.get(:medusa_url)
  end

  # method_missing()

  test 'method_missing() with a bogus config key returns nil' do
    assert_nil @config.bogus
  end

  test 'method_missing() with a valid config key returns the value' do
    assert_equal @config_struct[:medusa_url], @config.medusa_url
  end

end
