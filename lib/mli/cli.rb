require "thor"

module Mli
  module Cli
  end
end

loader = Zeitwerk::Loader.new
loader.push_dir("lib/mli/cli", namespace: Mli::Cli)
loader.setup
