# frozen_string_literal: true
require "ht_sip_validator/validation/base"

module HathiTrust

  class Validation::MetaYml::RequiredKeys < Validation::Base
    REQUIRED_KEYS = %w(capture_date).freeze
    def perform_validation
      REQUIRED_KEYS.map do |key|
        next if @sip.meta_yml.key?(key)
        create_error(
          validation: :has_field,
          human_message: "Missing required key #{key} in meta.yml",
          extras: { filename: "meta.yml",
                    field: key }
        )
      end
    end
  end

end
