require "set"

# frozen_string_literal: true
module HathiTrust::Validator

  # Validates that OCR all has corresponding images and that coordinate OCR has
  # corresponding plain-text OCR
  class OCR::HasImage < Base

    def perform_validation()
      ocr = sequence_map(:ocr)
      coord_ocr = sequence_map(:coord_ocr)
      images = sequence_map(:image)

      file_set_diff(ocr,'OCR',images,'image',".{tif,jp2}") +
        file_set_diff(coord_ocr,'Coordinate OCR',ocr,'plain-text OCR',".txt")
    end

    private

    def sequence_map(group)
      Hash[@sip.group_files(group).map { |f| [File.basename(f,".*"),f] }]
    end

    # Returns an error for each file in the set 'other' that isn't in the set 'base'
    # using the given names of the sets and file extension for the 'other' set
    def file_set_diff(base,base_name,other,other_name,other_ext)

      base.keys.to_set.difference(other.keys.to_set).map do |seq|
        create_error(
          validation_type: :file_present,
          human_message: "#{base_name} file #{base[seq]} has no corresponding #{other_name}",
          extras: { filename: "#{seq}.#{other_ext}" }
        )
      end
    end

  end

end
