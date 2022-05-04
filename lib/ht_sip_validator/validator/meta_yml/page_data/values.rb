# frozen_string_literal: true

require "ht_sip_validator/validator/base"
require "ht_sip_validator/validator/meta_yml/page_data/files"

module HathiTrust::Validator
  # Validate that the page data key in meta.yml has the expected keys & values
  class MetaYml::PageData::Values < Base
    def perform_validation
      @sip.metadata.fetch("pagedata", {}).map do |key, value|
        if value.is_a?(Hash)
          if value.keys.any? { |k| k != "label" && k != "orderlabel" }
            record_bad_pagedata_value(key, value)
          end
        else
          record_bad_pagedata_value(key, value)
        end
      end
    end

    private

    def record_bad_pagedata_value(key, value)
      create_error(
        validation_type: :field_valid,
        human_message: "The value #{value} for the pagedata for #{key} is not valid. "\
        " It should be specified as { label: 'pagetag', orderlabel: 'pagenumber' }",
        extras: {filename: "meta.yml",
                 field: "pagedata[#{key}]",
                 actual: value,
                 expected: "{ label: 'pagetag', orderlabel: 'pagenumber' }"}
      )
    end
  end
end
