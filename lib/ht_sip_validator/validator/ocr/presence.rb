require "set"

# frozen_string_literal: true
module HathiTrust::Validator

  # Validates that all images have corresponding plain-text OCR
  class OCR::Presence < Base

    include OCR

    def perform_validation
      ocr_seqs = sequence_map(:ocr)
      image_seqs = sequence_map(:image)
      missing_ocr_message = filegroup_message_template("image", "OCR", ".txt")

      file_set_diff(image_seqs, ocr_seqs).map do |seq|
        create_warning(missing_ocr_message.call(ocr_seqs, seq))
      end
    end

  end

end
