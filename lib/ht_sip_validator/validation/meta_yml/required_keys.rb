# frozen_string_literal: true
require "ht_sip_validator/validation/base"

module HathiTrust
  module Validation
    module MetaYml

      class RequiredKeys < Validation::Base
        REQUIRED_KEYS = %w(capture_date)
        def validate
          REQUIRED_KEYS.each do |key|
            unless @sip.meta_yml.has_key?(key)
              record_error(
                validation: :has_field,
                human_message: "Missing required key #{key} in meta.yml",
                extras: { filename: "meta.yml",
                  field: key }
              )

            end
          end

          super
        end
      end

    end
  end
end
