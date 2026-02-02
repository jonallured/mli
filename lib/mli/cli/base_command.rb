module Mli
  module Cli
    class BaseCommand < Thor
      class_option :pretty, type: :boolean, default: false, desc: "Format JSON response"

      def self.docs_for(topic, section)
        topic_data = File.read("#{__dir__}/../../../docs/#{topic}.txt")
        sections_data = {}
        topic_data.split("// ").each do |section_part|
          name, *rest = section_part.split("\n")
          sections_data[name] = rest.join("\n")
        end
        sections_data[section.to_s]
      end

      no_commands do
        def formatted(data)
          options[:pretty] ? JSON.pretty_generate(data) : JSON.generate(data)
        end
      end
    end
  end
end
