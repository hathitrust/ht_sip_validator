# frozen_string_literal: true
require "ht_sip_validator/validation/base"

module HathiTrust::Validation
  # Validates that package contains meta.yml
  class MetaYml::Exists < Base
    def perform_validation
      unless @sip.files.include?("meta.yml")
        create_error(
          validation: :exists,
          human_message: "SIP is missing meta.yml",
          extras: { filename: "meta.yml" }
        )
      end
    end
  end
end
