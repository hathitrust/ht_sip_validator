require "set"

# frozen_string_literal: true
module HathiTrust::Validator

  # Validates that all images have corresponding plain-text OCR
  class OCR::CoordinateHasPlain < Base

    include OCR

    def perform_validation
      ocr_seqs = sequence_map(:ocr)
      coord_ocr_seqs = sequence_map(:coord_ocr)
      missing_ocr_message = filegroup_message_template("Coordinate OCR", "plain-text OCR", ".txt")

      file_set_diff(coord_ocr_seqs, ocr_seqs).map do |seq|
        create_error(missing_ocr_message.call(coord_ocr_seqs, seq))
      end
    end

  end

end
