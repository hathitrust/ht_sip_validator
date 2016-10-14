# frozen_string_literal: true
require "ht_sip_validator/validation/base"

module HathiTrust
  module Validation
    module MetaYml

      # Validates that package contains meta.yml
      class DateFormat < Validation::Base
        def perform_validation
          Message.new(
            validator: 1,
            validation: 2,
            level: 3,
            human_message: "test",
            extras: {}
          )
        end
      end

    end
  end
end
