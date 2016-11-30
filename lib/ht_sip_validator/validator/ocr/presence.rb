require "set"

# frozen_string_literal: true
module HathiTrust::Validator

  # Validates that all images have corresponding plain-text OCR
  class OCR::Presence < Base

    include OCR

    def perform_validation
      file_set_diff(sequence_map(:image), "image", sequence_map(:ocr), "OCR", ".txt", :warning)
    end

  end

end
