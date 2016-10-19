# frozen_string_literal: true
require "ht_sip_validator/validation/base"
require "ht_sip_validator/validation/meta_yml/page_data/files.rb"

module HathiTrust::Validation
  # Validate that the page data key in meta.yml has the expected keys & values
  class MetaYml::PageData::Presence < Base
    def perform_validation
      unless @sip.meta_yml.key?("pagedata")
        create_warning(
          validation: :field_presence,
          human_message: "'pagedata' is not present in meta.yml; "\
          "users will not have page tags or page numbers to navigate through this book.",
          extras: { filename: "meta.yml",
                    field: "pagedata" }
        )
      end
    end
  end
end
