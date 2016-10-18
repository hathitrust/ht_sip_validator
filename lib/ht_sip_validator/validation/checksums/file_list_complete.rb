# frozen_string_literal: true
require "ht_sip_validator/validation/base"

module HathiTrust::Validation::Checksums
  # validates that checksums exist for all files in the sip
  class FileListComplete < HathiTrust::Validation::Base
    def perform_validation
      errors = @sip.files.map do |filename|
        # The filename needs to have a checksum OR the filename needs to be on the exempt list
        unless @sip.checksums.checksum_for(filename) || EXEMPT_FILENAMES.include?(filename)
          create_error(
            validation: :file_list_complete,
            human_message: "SIP Checksums is missing checksum for file #{filename}",
            extras: { filename: filename }
          )
        end
      end
      errors.compact
    end
  end
end
