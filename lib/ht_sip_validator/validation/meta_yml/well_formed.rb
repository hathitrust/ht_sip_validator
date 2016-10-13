# frozen_string_literal: true
require "ht_sip_validator/validation/base"

module HathiTrust
  module Validation
    module MetaYml

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

    end
  end
end
