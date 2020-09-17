require 'rspec/mocks'
require 'rspec/expectations'

module RSpecMocksIntegration
  include ::RSpec::Mocks::ExampleMethods
  include ::RSpec::Matchers

  def before_setup
    ::RSpec::Mocks.setup
    super
  end

  def before_teardown
    super
    ::RSpec::Mocks.verify
  end

  def after_teardown
    super
    ::RSpec::Mocks.teardown
  end
end
Minitest::Test.send(:include, RSpecMocksIntegration)
