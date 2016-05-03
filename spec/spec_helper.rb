require 'simplecov'
require 'coveralls'

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter.new([
  SimpleCov::Formatter::HTMLFormatter,
  Coveralls::SimpleCov::Formatter
])
SimpleCov.start { add_filter '/spec/' }

require 'lita-alertlogic'
require 'lita/rspec'

Lita.version_3_compatibility_mode = false

RSpec.configure do |config|
  config.before do
    registry.register_handler(Lita::Handlers::AlertlogicCustomer)
    registry.register_handler(Lita::Handlers::AlertlogicLogManager)
    registry.register_handler(Lita::Handlers::AlertlogicThreatManager)
    registry.register_handler(Lita::Handlers::AlertlogicMonitoring)
    registry.register_handler(Lita::Handlers::AlertlogicIncidents)
  end

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.filter_run :focus
  config.run_all_when_everything_filtered = true
  config.default_formatter = 'doc' if config.files_to_run.one?
  config.order = :random

  Kernel.srand config.seed
end
