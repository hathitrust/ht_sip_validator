# frozen_string_literal: true
require "ht_sip_validator/validation/base"

module HathiTrust::Validation::Checksums
  # validates that package contains checksums
  class Exists < HathiTrust::Validation::Base
    def perform_validation
      unless @sip.files.include?(HathiTrust::SIP::CHECKSUM_FILE)
        create_error(
          validation: :exists,
          human_message: "SIP is missing #{HathiTrust::SIP::CHECKSUM_FILE}",
          extras: { filename: HathiTrust::SIP::CHECKSUM_FILE }
        )
      end
    end
  end
end
