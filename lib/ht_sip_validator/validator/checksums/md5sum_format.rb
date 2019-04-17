# frozen_string_literal: true
require "ht_sip_validator/validator/base"

module HathiTrust::Validator::Checksums
  # validates that package contains checksums as formatted by md5sum
  class MD5SumFormat < HathiTrust::Validator::Base
    def perform_validation
      @sip.raw_checksums.each_line.map do |line|
        unless line.match(/^[a-fA-F0-9]{32} [ *]/) or line.match(/^#/) or line.match(/^\s*$/)
          create_warning(
            validation_type: :well_formed,
            human_message: "checksum.md5 includes a line that does not match the expected format -- it should be UTF-8 text, with checksum first, followed by whitespace, followed by the filename (as created by md5sum)",
            extras: { actual: line.strip }
          )
        end
      end
    end
  end
end
