require "set"

# frozen_string_literal: true
module HathiTrust::Validator

  # Validates that OCR all has corresponding images and that coordinate OCR has
  # corresponding plain-text OCR
  class OCR::CoordinatePresence < Base

    include OCR

    def perform_validation
      file_set_diff(sequence_map(:ocr), "plain-text OCR",
        sequence_map(:coord_ocr), "coordinate OCR",
        ".{xml,html}", :warning)
    end

  end

end
