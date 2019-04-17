# frozen_string_literal: true
module HathiTrust::SIP
  # Handles MD5 checksums in a checksum.md5 or similar format
  class Checksums
    # @return [Hash] all checksums in the given collection
    attr_reader :checksums

    # Initialize a new set of Checksums. Ignores directory names in the
    # file names.
    #
    # @param checksum_file [IO] IO stream (or anything responding to
    # #each_line) that contains a list of checksums and files
    def initialize(checksum_file)
      @checksums = {}

      check_for_bom(checksum_file).each_line() do |line|

        if m = line.strip.match(/\b[a-fA-F0-9]{32}\b/) and filename = extract_filename(m)
          checksum = m.to_s.downcase
          @checksums[File.basename(filename)] = checksum
        end
      end
    end

    def checksum_for(filename)
      @checksums[filename]
    end

    private

    def check_for_bom(checksum_file)
      maybe_bom = checksum_file.bytes[0,2]

      if maybe_bom == [0xFF,0xFE]
        encoding = 'UTF-16LE'
      elsif maybe_bom == [0xFE,0xFF]
        encoding = 'UTF-16BE'
      end

      if encoding
        checksum_file.force_encoding(encoding)[1..-1].encode("US-ASCII")
      else
        checksum_file
      end
    end

    def extract_filename(match)
      (match.pre_match.strip + match.post_match.strip).
        # Remove delimeters & random asterisks that some md5 programs put in there.
        # Hope nobody has legit filenames with leading or trailing commas or asterisks
        gsub(/^[*,]/,'').
        gsub(/[*,]$/,'').
        # Handle windows-style paths
        tr('\\','/').
        downcase
    end
  end
end
