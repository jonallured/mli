require "faraday"
require "zeitwerk"

loader = Zeitwerk::Loader.for_gem
loader.ignore("lib/mli/cli*")
loader.setup

module Mli
end
