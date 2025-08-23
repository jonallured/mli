require "thor"

module Mli
  class CLI < Thor
    desc "version", "Print the version"
    def version
      say Mli::VERSION
    end

    def self.basename
      "mli"
    end

    def self.exit_on_failure?
      true
    end
  end
end
