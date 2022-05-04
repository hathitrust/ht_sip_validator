require "set"

# frozen_string_literal: true
module HathiTrust::Validator
  # Validates that provided coordinate OCR is all the same apparent format.
  class OCR::CoordinateFormat < Base
    def perform_validation
      if @sip.group_files(:coord_ocr).map { |f| File.extname(f) }.uniq.count > 1
        create_warning(
          validation_type: :filename_valid,
          human_message: "Coordinate OCR has both xml and html files"
        )
      end
    end
  end
end
