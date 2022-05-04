# frozen_string_literal: true

require "ht_sip_validator/validator/base"

module HathiTrust::Validator
  # Validates that meta.yml is loadable & parseable
  class MetaYml::WellFormed < Base
    def perform_validation
      @sip.metadata
      []
    rescue RuntimeError => e
      create_error(
        validation_type: :well_formed,
        human_message: "Couldn't parse meta.yml",
        extras: {filename: "meta.yml",
                 root_cause: e.message}
      )
    end
  end
end
