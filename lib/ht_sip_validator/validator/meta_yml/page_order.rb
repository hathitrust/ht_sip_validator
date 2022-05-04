# frozen_string_literal: true

require "ht_sip_validator/validator/base"
require "set"

module HathiTrust::Validator
  # Validates that meta.yml is loadable & parseable
  class MetaYml::PageOrder < Base
    ALLOWED_ORDERINGS = %w[right-to-left left-to-right].freeze
    ORDER_FIELDS = %w[scanning_order reading_order].freeze

    def perform_validation
      if ORDER_FIELDS.all? { |key| @sip.metadata.key?(key) }
        validate_page_ordering_values
      elsif ORDER_FIELDS.none? { |key| @sip.metadata.key?(key) }
        default_page_ordering_warning
      else
        missing_one_page_order
      end
    end

    private

    def missing_one_page_order
      if @sip.metadata.key?("reading_order")
        page_ordering_error(has: "reading_order", missing: "scanning_order")
      else
        page_ordering_error(has: "scanning_order", missing: "reading_order")
      end
    end

    def validate_page_ordering_values
      ORDER_FIELDS.map do |key|
        value = @sip.metadata[key]
        unless ALLOWED_ORDERINGS.include?(value)
          create_error(validation_type: :field_valid,
            human_message: "#{key} in meta.yml was #{value}, "\
             "but it must be one of #{ALLOWED_ORDERINGS}.",
            extras: {filename: "meta.yml", field: key, actual: value,
                     expected: ALLOWED_ORDERINGS})
        end
      end
    end

    def page_ordering_error(has:, missing:)
      create_error(
        validation_type: :has_field,
        human_message: "meta.yml has #{has} but was missing #{missing}. "\
          "If one is provided, both must be.",
        extras: {filename: "meta.yml",
                 field: missing}
      )
    end

    def default_page_ordering_warning
      create_warning(
        validation_type: :has_field,
        human_message: "Neither scanning_order or reading_order provided; "\
          "they will default to left-to-right",
        extras: {filename: "meta.yml",
                 field: ORDER_FIELDS}
      )
    end
  end
end
