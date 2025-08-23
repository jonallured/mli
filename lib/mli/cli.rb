require "thor"

module Mli
  class CLI < Thor
    def self.basename
      "mli"
    end

    def self.exit_on_failure?
      true
    end
  end
end
