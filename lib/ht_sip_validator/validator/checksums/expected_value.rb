# frozen_string_literal: true
require "ht_sip_validator/validator/base"
require "digest"

module HathiTrust::Validator::Checksums
  # validates that checksums file values match calculated values
  class ExpectedValue < HathiTrust::Validator::FileValidator

    def perform_file_validation(filename, filehandle)
      checksum_from_sip = @sip.checksums.checksum_for(filename)
      if checksum_from_sip.nil?
        missing_checksum_error filename
      elsif checksum_from_sip != calculated_checksum(filehandle)
        mismatch_checksum_error filename
      end
    end

    def should_validate?(filename)
      !EXEMPT_FILENAMES.include? filename
    end

    # @param instream [IO] A readable IO object.
    # @return MD5 hex string
    # It is incumbent on the caller to clean it up the io object.
    def calculated_checksum(instream)
      Digest::MD5.hexdigest(instream.read)
    end

    def mismatch_checksum_error(filename)
      create_error(
        validation_type: :expected_checksum_value,
        human_message: "Checksum mismatch for #{filename}",
        extras: { filename: filename }
      )
    end

    def missing_checksum_error(filename)
      create_error(
        validation_type: :expected_checksum_value,
        human_message: "Checksum missing for #{filename}",
        extras: { filename: filename }
      )
    end

  end
end
