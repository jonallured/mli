require "faraday"
require "faraday/multipart"
require "zeitwerk"

module Mli
end

loader = Zeitwerk::Loader.for_gem
loader.ignore("#{__dir__}/mli/cli*")
loader.push_dir("#{__dir__}/mli/resources", namespace: Mli)
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
