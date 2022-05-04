require "set"

# frozen_string_literal: true
module HathiTrust::Validator
  # Validates that OCR all has corresponding images and that coordinate OCR has
  # corresponding plain-text OCR
  class OCR::CoordinatePresence < Base
    include OCR

    def perform_validation
      ocr_seqs = sequence_map(:ocr)
      coord_ocr_seqs = sequence_map(:coord_ocr)
      missing_coord_message = filegroup_message_template("plain-text OCR",
        "coordinate OCR", ".{xml,html}")

      file_set_diff(ocr_seqs, coord_ocr_seqs).map do |seq|
        create_warning(missing_coord_message.call(ocr_seqs, seq))
      end
    end
  end
end
