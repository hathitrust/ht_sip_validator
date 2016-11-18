# frozen_string_literal: true

# namespace for validators for meta.yml
module HathiTrust::Validator::Package
end

require "ht_sip_validator/validator/package/file_basenames"
require "ht_sip_validator/validator/package/duplicate_filenames"
require "ht_sip_validator/validator/package/extra_files"
require "ht_sip_validator/validator/package/pdf_count"
require "ht_sip_validator/validator/package/marcxml"
require "ht_sip_validator/validator/package/file_types"
