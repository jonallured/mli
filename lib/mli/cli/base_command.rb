module Mli
  module Cli
    class BaseCommand < Thor
      class_option :pretty, type: :boolean, default: false, desc: "Format JSON response."

      def self.attrs_for(args)
        Array(args).each_with_object({}) do |pair, memo|
          key, value = pair.split(":")
          next unless key && value

          memo[key] = value
        end
      end

      def self.docs_for(topic, section)
        topic_data = File.read("docs/#{topic}.txt")
        sections_data = {}
        topic_data.split("// ").each do |section_part|
          name, *rest = section_part.split("\n")
          sections_data[name] = rest.join("\n")
        end
        sections_data[section.to_s]
      end

      private

      def attrs_for(args)
        self.class.attrs_for(args)
      end

      def formatted(data)
        options["pretty"] ? JSON.pretty_generate(data) : JSON.generate(data)
      end
    end
  end
end
