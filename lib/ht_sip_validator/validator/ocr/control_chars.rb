require "set"

# frozen_string_literal: true
module HathiTrust::Validator
  # Validates that provided coordinate OCR is UTF-8
  class OCR::ControlChars < FileValidator
    def perform_file_validation(filename, filehandle)
      if /[\x00-\x08\x0B\x0C\x0E-\x1F]/.match?(filehandle.read)
        create_error(validation_type: :file_valid,
          human_message: "File #{filename} contains disallowed control characters",
          extras: {file: filename})
      end
    end

    def should_validate?(filename)
      !filename.match(/\.(txt|html|xml)$/).nil?
    end
  end
end
