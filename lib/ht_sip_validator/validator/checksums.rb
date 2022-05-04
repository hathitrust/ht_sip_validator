# frozen_string_literal: true

module HathiTrust::Validator::Checksums
  # File names that are exempt from having checksums
  EXEMPT_FILENAMES = [HathiTrust::SIP::CHECKSUM_FILE, "Thumbs.db", ".DS_Store"].freeze
end

require "ht_sip_validator/validator/checksums/exists"
require "ht_sip_validator/validator/checksums/file_list_complete"
require "ht_sip_validator/validator/checksums/well_formed"
require "ht_sip_validator/validator/checksums/expected_value"
require "ht_sip_validator/validator/checksums/md5sum_format"
