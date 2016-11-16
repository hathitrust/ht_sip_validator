# frozen_string_literal: true
require "ht_sip_validator/validator/base"
require "set"

module HathiTrust::Validator

  # Validates that there is at most one PDF file in the SIP
  class Package::PDFCount < Base
    def perform_validation
      @sip.files.select {|f| File.extname(f) == ".pdf" }
        .drop(1)
        .map do |filename|
        create_error(
          validation_type: :file_absent,
          human_message: "Extra PDF file #{filename}. "\
          "Only one PDF file should be included.",
          extras: { filename: filename }
        )
      end
    end
  end
end
