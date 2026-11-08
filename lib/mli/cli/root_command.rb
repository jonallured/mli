module Mli
  module Cli
    class RootCommand < Thor
      desc "book", "Use /api/v1/books endpoint family"
      subcommand "book", BookCommand

      desc "boop", "Use /api/v1/boops endpoint family"
      subcommand "boop", BoopCommand

      desc "financial_account", "Use /api/v1/financial_accounts endpoint family"
      subcommand "financial_account", FinancialAccountCommand

      desc "financial_statement", "Use /api/v1/financial_statements endpoint family"
      subcommand "financial_statement", FinancialStatementCommand

      desc "financial_transaction", "Use /api/v1/financial_transactions endpoint family"
      subcommand "financial_transaction", FinancialTransactionCommand

      desc "ping", "Use /api/v1/ping endpoint family"
      subcommand "ping", PingCommand

      desc "vanishing_message", "Use /api/v1/vanishing_messages endpoint family"
      subcommand "vanishing_message", VanishingMessageCommand

      desc "warm_fuzzy", "Use /api/v1/warm_fuzzies endpoint family"
      subcommand "warm_fuzzy", WarmFuzzyCommand

      desc "version", "Print the version number"
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
end
