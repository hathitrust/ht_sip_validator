require "set"

# frozen_string_literal: true
module HathiTrust::Validator
  # Validates that provided coordinate OCR is UTF-8
  class OCR::UTF8 < FileValidator
    def perform_file_validation(filename, filehandle)
      check_utf8(filename, filehandle)
    end

    def should_validate?(filename)
      !filename.match(/\.(txt|html|xml)$/).nil?
    end

    private

    def check_utf8(filename, filehandle)
      messages = []
      s = filehandle.read
      s.force_encoding("utf-8")
      # check the string for invalid bytes and bail at the first one
      s.scrub do |invalid|
        messages << create_error(
          validation_type: :file_valid,
          human_message: "File #{filename} is not valid UTF-8: invalid byte #{invalid.inspect} found.",
          extras: {file: filename}
        )
        break
      end
      messages
    end
  end
end
