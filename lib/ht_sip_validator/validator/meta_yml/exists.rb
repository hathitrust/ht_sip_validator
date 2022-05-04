# frozen_string_literal: true

require "ht_sip_validator/validator/base"

module HathiTrust::Validator
  # Validates that package contains meta.yml
  class MetaYml::Exists < Base
    def perform_validation
      unless @sip.files.include?("meta.yml")
        create_error(
          validation_type: :exists,
          human_message: "SIP is missing meta.yml",
          extras: {filename: "meta.yml"}
        )
      end
    end
  end
end
