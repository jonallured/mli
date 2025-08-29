require "mli"
require "mli/cli"

require "support/use_test_adapter"

RSpec.configure do |config|
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.include_context "use test adapter"
end
