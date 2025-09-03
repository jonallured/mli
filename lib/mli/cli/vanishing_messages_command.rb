module Mli
  module Cli
    class VanishingMessagesCommand < BaseCommand
      desc "create ATTRS", "Create VanishingMessage record with ATTRS"
      long_desc docs_for(:vanishing_messages, :create), wrap: false
      def create(*args)
        vanishing_message_attrs = attrs_for(args)
        vanishing_message_data = VanishingMessages.create(vanishing_message_attrs)
        say formatted(vanishing_message_data)
      end
    end
  end
end
