require "faraday"
require "zeitwerk"

loader = Zeitwerk::Loader.for_gem
loader.ignore("#{__dir__}/mli/cli*")
loader.setup

module Mli
  def self.config
    @config ||= Config.new(ENV, [Faraday.default_adapter])
  end

  def self.connection
    @connection ||= Connection.generate(config)
  end

  def self.reset(config)
    @config = config
    @connection = nil
    connection
  end
end
