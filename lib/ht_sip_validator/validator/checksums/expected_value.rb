# frozen_string_literal: true
require "ht_sip_validator/validator/base"
require "digest"
require "pry"

module HathiTrust::Validator::Checksums
  # validates that checksums file values match calculated values
  class ExpectedValue < HathiTrust::Validator::Base
    attr :calculated

    def perform_validation
      checksumed_files = @sip.files - EXEMPT_FILENAMES
      @calculated = calculate_checksums

      checksumed_files.map do |filename|
        if @sip.checksums.checksum_for(filename) != calculated_checksum_for(filename)
          error_for filename
        end
      end
    end

    def calculated_checksum_for(filename)
      @calculated[filename]
    end

    def error_for(filename)
      create_error(
        validation_type: :expected_checksum_value,
        human_message: "Checksum mismatch for #{filename}",
        extras: { filename: filename }
      )
    end

    private 

    def calculate_checksums
      calculated = Hash.new
      @sip.each_file do |filename, instream|
          calculated[filename] = Digest::MD5.hexdigest(instream.read)
      end
      return calculated
    end
  end
end
