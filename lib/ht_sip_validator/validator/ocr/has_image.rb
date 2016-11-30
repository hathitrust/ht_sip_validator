require "set"

# frozen_string_literal: true
module HathiTrust::Validator

  # Validates that OCR all has corresponding images and that coordinate OCR has
  # corresponding plain-text OCR
  class OCR::HasImage < Base

    include OCR

    def perform_validation
      ocr = sequence_map(:ocr)
      coord_ocr = sequence_map(:coord_ocr)
      images = sequence_map(:image)

      file_set_diff(ocr, "OCR", images, "image", ".{tif,jp2}", :error) +
        file_set_diff(coord_ocr, "Coordinate OCR", ocr, "plain-text OCR", ".txt", :error)
    end

  end

end
