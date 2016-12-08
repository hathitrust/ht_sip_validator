require "set"

# frozen_string_literal: true
module HathiTrust::Validator

  # Validates that OCR all has corresponding images and that coordinate OCR has
  # corresponding plain-text OCR
  class OCR::HasImage < Base

    include OCR

    def perform_validation
      ocr_seqs = sequence_map(:ocr)
      image_seqs = sequence_map(:image)
      missing_image_message = filegroup_message_template("OCR", "image", ".{tif,jp2}")

      file_set_diff(ocr_seqs, image_seqs).map do |seq|
        create_error(missing_image_message.call(ocr_seqs, seq))
      end
    end

  end

end
