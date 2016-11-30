# frozen_string_literal: true

# namespace for validators for meta.yml
module HathiTrust::Validator::OCR
  # Returns an error for each file in the set 'other' that isn't in the set 'base'
  # using the given names of the sets and file extension for the 'other' set
  def file_set_diff(base, base_name, other, other_name, other_ext, message_level)
    message_level_method = "create_#{message_level}"

    base.keys.to_set.difference(other.keys.to_set).map do |seq|
      send(message_level_method,
        validation_type: :file_present,
        human_message: "#{base_name} file #{base[seq]} has no corresponding #{other_name} #{seq}#{other_ext}",
        extras: { filename: "#{seq}#{other_ext}" })
    end
  end

  def sequence_map(group)
    Hash[@sip.group_files(group).map {|f| [File.basename(f, ".*"), f] }]
  end

end

require "ht_sip_validator/validator/ocr/coordinate_presence"
require "ht_sip_validator/validator/ocr/coordinate_format"
require "ht_sip_validator/validator/ocr/has_image"
require "ht_sip_validator/validator/ocr/presence"
