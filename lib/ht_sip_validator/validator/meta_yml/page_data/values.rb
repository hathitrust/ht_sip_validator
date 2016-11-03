# frozen_string_literal: true
require "ht_sip_validator/validator/base"
require "ht_sip_validator/validator/meta_yml/page_data/files.rb"

module HathiTrust::Validator
  # Validate that the page data key in meta.yml has the expected keys & values
  class MetaYml::PageData::Values < Base

    def perform_validation
      @sip.meta_yml["pagedata"].map do |key, value|
        if value.is_a?(Hash)
          value.keys
            .select {|k| k != "label" && k != "orderlabel" }
            .each do |pagedata_key|
            record_bad_pagedata_value(key, pagedata_key)
          end
        else
          record_bad_pagedata_value(key, value)
        end
      end
    end

    private

    def record_bad_pagedata_value(key, value)
      create_error(
        validation: :field_valid,
        human_message: "The value #{value} for the pagedata for #{key} is not valid. "\
        " It should be specified as { label: 'pagetag', orderlabel: 'pagenumber' }",
        extras: { filename: "meta.yml",
                  field: "pagedata[#{key}]",
                  actual: value,
                  expected: "{ label: 'pagetag', orderlabel: 'pagenumber' }" }
      )
    end
  end
end
