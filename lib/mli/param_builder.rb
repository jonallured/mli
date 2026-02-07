# remove once minimum Ruby is 3.4
require "time"

module Mli
  class ParamBuilder
    BASIC_CONTENT_TYPES = {
      "csv" => "text/csv",
      "gif" => "image/gif",
      "jpeg" => "image/jpeg",
      "jpg" => "image/jpeg",
      "json" => "application/json",
      "pdf" => "application/pdf",
      "png" => "image/png",
      "txt" => "text/plain"
    }

    def self.content_type_for(filename)
      extension = (filename || "").split(".").last
      BASIC_CONTENT_TYPES[extension]
    end

    def self.from(attrs, as_of = Time.now.utc)
      builder = new(attrs, as_of)
      builder.run
      builder.params
    end

    attr_reader :attrs, :params

    def initialize(attrs, as_of)
      @attrs = attrs || {}
      @params = {}
      @as_of = as_of
    end

    def run
      build_dates
      build_times
      build_files
      build_remaining
    end

    private

    def build_dates
      date_keys = @attrs.keys.select { |key| key.match?(/.*_on$/) }
      date_keys.each do |key|
        value = (@attrs[key] == "today") ? @as_of.to_date.iso8601 : @attrs[key]
        @params[key] = value
      end
    end

    def build_times
      time_keys = @attrs.keys.select { |key| key.match?(/.*_at$/) }
      time_keys.each do |key|
        value = (@attrs[key] == "now") ? @as_of.iso8601 : @attrs[key]
        @params[key] = value
      end
    end

    def build_files
      path_keys = @attrs.keys.select { |key| key.match?(/.*_path$/) }
      path_keys.each do |path_key|
        file_path = @attrs[path_key]
        content_type = ParamBuilder.content_type_for(file_path)
        value = Faraday::Multipart::FilePart.new(file_path, content_type)
        key = path_key.to_s.gsub("_path", "").to_sym
        @params[key] = value
      end
    end

    def build_remaining
      remaining = @attrs.keys - @params.keys
      remaining.each { |key| @params[key] = @attrs[key] }
      @params.compact!
    end
  end
end
