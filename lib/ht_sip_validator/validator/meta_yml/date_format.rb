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
          DateTime.strptime(sip.metadata[field] || "", DATE_FORMAT)
        rescue ArgumentError
          messages << create_error(
            validation_type: field.to_sym,
            human_message: "An iso8601 combined date is required for #{field} in meta.yml.",
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

  end
end
