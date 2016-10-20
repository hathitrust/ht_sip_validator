# frozen_string_literal: true
require "ht_sip_validator/validation/base"

module HathiTrust::Validation

  # Validates that meta.yml is loadable & parseable
  class MetaYml::WellFormed < Base
    def perform_validation
      @sip.meta_yml
      return []
    rescue RuntimeError => e
      return create_error(
        validation: :well_formed,
        human_message: "Couldn't parse meta.yml",
        extras: { filename: "meta.yml",
                  root_cause: e.message }
      )
    end
  end

end
