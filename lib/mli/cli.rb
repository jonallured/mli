require "thor"

module Mli
  module Cli
  end
end

loader = Zeitwerk::Loader.new
loader.push_dir("#{__dir__}/cli", namespace: Mli::Cli)
loader.setup
