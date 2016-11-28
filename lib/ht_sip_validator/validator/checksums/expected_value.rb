# frozen_string_literal: true
require "ht_sip_validator/validator/base"
require "digest"
require "pry"

module HathiTrust::Validator::Checksums
  # validates that checksums file values match calculated values
  class ExpectedValue < HathiTrust::Validator::Base

    def perform_validation
      checksumed_files = @sip.files - EXEMPT_FILENAMES
      checksumed_files.map do |filename|
        if @sip.checksums.checksum_for(filename) != calculated_checksum_for(filename)
          create_error(
            validation_type: :expected_checksum_value,
            human_message: "Checksum mismatch for #{filename}",
            extras: { filename: filename }
          )
        end
      end
    end

    # WARN! using private method
    def calculated_checksum_for(file)
      @sip.send(:file_in_zip, file) do | filestream |
        Digest::MD5.hexdigest(filestream.read)
      end
    end

  end
end
