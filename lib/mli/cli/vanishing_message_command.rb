module Mli
  module Cli
    class VanishingMessageCommand < BaseCommand
      desc "create", "Create VanishingMessage resource"
      long_desc docs_for(:vanishing_message, :create), wrap: false
      option :body, type: :string, required: true
      def create
        vanishing_message_attrs = {
          body: options[:body]
        }
        vanishing_message_data = VanishingMessage.create(vanishing_message_attrs)
        say formatted(vanishing_message_data)
      end
    end
  end
end
