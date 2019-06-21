# frozen_string_literal: true
require "ht_sip_validator/validator/base"
require "date"

module HathiTrust::Validator
  # Validates that package contains correctly formatted
  # capture_date and image_compression_date

  class MetaYml::DateFormat < Base
    FIELDS = ["capture_date", "image_compression_date"].freeze
    DATE_FORMAT = "%FT%T%:z".freeze

    # regex from edtfRegularExpressions in https://www.loc.gov/standards/premis/v2/premis-v2-3.xsd
    DATE_REGEX = %r{\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}((Z|(\+|-)\d{2}:\d{2}))?}

    def perform_validation
      [].tap do |messages|
        FIELDS.each do |field|
          begin
            next if sip.metadata[field].nil?
            raise ArgumentError unless sip.metadata[field].match?(DATE_REGEX)
            DateTime.strptime(sip.metadata[field], DATE_FORMAT)

          rescue ArgumentError
            messages << error_for(field)
          end
        end
      end
    end

    def human_message(field)
      "An iso8601 combined date (e.g 2016-12-08T01:02:03-05:00) is required for #{field} in meta.yml."
    end

    private

    def error_for(field)
      create_error(
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
end
