# frozen_string_literal: true
require "ht_sip_validator/validator/base"

module HathiTrust::Validator::Checksums
  # validates that checksums values are well formed
  class WellFormed < HathiTrust::Validator::Base
    def perform_validation
      checksum_values = @sip.checksums.checksums.values
      checksum_pattern = Regexp.new("^[a-f0-9]{32}$", Regexp::IGNORECASE)

      errors = checksum_values.map do |checksum_val|
        unless checksum_pattern.match checksum_val
          create_error(
            validation_type: :well_formed,
            human_message: "SIP Checksums has malformed value: #{checksum_val}",
            extras: { checksum: checksum_val }
          )
        end
      end
      errors.compact
    end
  end
end
