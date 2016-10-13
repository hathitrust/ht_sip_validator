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

    end
  end
end
