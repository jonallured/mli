module Mli
  module Cli
    class VanishingMessagesCommand < BaseCommand
      desc "create", "Create VanishingMessage resource"
      long_desc docs_for(:vanishing_messages, :create), wrap: false
      option :body, type: :string, required: true
      def create
        vanishing_message_attrs = {
          body: options[:body]
        }
        vanishing_message_data = VanishingMessages.create(vanishing_message_attrs)
        say formatted(vanishing_message_data)
      end
    end
  end
end
