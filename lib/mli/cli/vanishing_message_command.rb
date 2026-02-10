module Mli
  module Cli
    class VanishingMessageCommand < BaseCommand
      desc "create", "Create VanishingMessage resource"
      long_desc docs_for(:vanishing_message, :create), wrap: false
      option :body, type: :string, required: true
      def create
        attrs = options.slice(:body)
        data = VanishingMessage.create(attrs)
        say formatted(data)
      end
    end
  end
end
