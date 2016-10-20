# frozen_string_literal: true
module HathiTrust::Validation::Checksums
  # File names that are exempt from having checksums
  EXEMPT_FILENAMES = [HathiTrust::SIP::CHECKSUM_FILE, 'Thumbs.db', '.DS_Store']
end

require "ht_sip_validator/validation/checksums/exists"
require "ht_sip_validator/validation/checksums/file_list_complete"
require "ht_sip_validator/validation/checksums/well_formed"
