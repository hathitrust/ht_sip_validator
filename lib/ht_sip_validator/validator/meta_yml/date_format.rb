# frozen_string_literal: true
require "ht_sip_validator/validator/base"
require "date"

module HathiTrust::Validator
  # Validates that package contains correctly formatted
  # capture_date and image_compression_date

  class MetaYml::DateFormat < Base
    FIELDS = ["capture_date", "image_compression_date"].freeze
    DATE_FORMAT = "%FT%T%:z".freeze

    def perform_validation
      messages = []
      FIELDS.each do |field|
        begin
          unless sip.metadata[field].nil?
            DateTime.strptime(sip.metadata[field], DATE_FORMAT)
          end
        rescue ArgumentError
          messages << create_error(
            validation_type: field.to_sym,
            human_message: human_message(field),
            extras: {
              filename: "meta.yml",
              field: field,
              actual: sip.metadata[field]
            }
          )
        end
      end
      return messages
    end

    def human_message(field)
      "An iso8601 combined date (e.g 2016-12-08T01:02:03-05:00) is required for #{field} in meta.yml."
    end

  end
end
