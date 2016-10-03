# frozen_string_literal: true
require "ht_sip_validator/validation/base"

module HathiTrust
  module Validation
    module MetaYml
      # Validates that package contains meta.yml
      class Exists < Validation::Base
        def validate
          unless @sip.files.include?("meta.yml")
            record_error(
              validation: :exists,
              human_message: "SIP is missing meta.yml",
              extras: { filename: "meta.yml" }
            )
          end

          super
        end
      end

      # Validates that meta.yml is loadable & parseable
      class WellFormed < Validation::Base
        def validate
          begin
            @sip.meta_yml
          rescue RuntimeError => e
            record_error(
              validation: :well_formed,
              human_message: "Couldn't parse meta.yml",
              extras: { filename: "meta.yml",
                        root_cause: e.message }
            )
          end

          super
        end
      end

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
