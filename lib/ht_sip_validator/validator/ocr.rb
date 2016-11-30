# frozen_string_literal: true

# namespace for validators for meta.yml
module HathiTrust::Validator::OCR
  # Returns each file in the keys of 'other' that isn't in the keys of 'base'
  def file_set_diff(base, other)
    base.keys.to_set.difference(other.keys.to_set)
  end

  def filegroup_message_template(base_name, other_name, other_ext)
    proc do |base, seq|
      { validation_type: :file_present,
        human_message: "#{base_name} file #{base[seq]} has no "\
        "corresponding #{other_name} #{seq}#{other_ext}",
        extras: { filename: "#{seq}#{other_ext}" } }
    end
  end

  # Convenience method to make a hash which maps sequences to their
  # corresponding filenames within a group of files.
  #
  # @param [Symbol] group of files to sequence
  # @return [Hash] sequences for the given group and corresponding filenames.
  # e.g. {'00000001': '00000001.jp2', '00000002': '00000002.tif' }
  #
  def sequence_map(group)
    Hash[@sip.group_files(group).map {|f| [File.basename(f, ".*"), f] }]
  end

end

require "ht_sip_validator/validator/ocr/coordinate_presence"
require "ht_sip_validator/validator/ocr/coordinate_has_plain"
require "ht_sip_validator/validator/ocr/coordinate_format"
require "ht_sip_validator/validator/ocr/has_image"
require "ht_sip_validator/validator/ocr/presence"
require "ht_sip_validator/validator/ocr/utf8"
