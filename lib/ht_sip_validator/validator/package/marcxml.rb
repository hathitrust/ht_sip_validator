require "set"

# frozen_string_literal: true
module HathiTrust::Validator
  # Warn if marc.xml is present
  class Package::MarcXML < Base
    def perform_validation
      if @sip.files.include?("marc.xml")
        create_warning(
          validation_type: :file_absent,
          human_message: "marc.xml is not necessary: metadata will "\
            " automatically be fetched from Zephir",
          extras: {filename: "marc.xml"}
        )
      end
    end
  end
end
