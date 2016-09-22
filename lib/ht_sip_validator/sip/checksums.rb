module HathiTrust
  module SIP

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
        checksum_file.each_line do |line|
          line.strip.match(/^([a-fA-F0-9]{32})(\s+\*?)(\S.*)/) do |m|
            (checksum, _, filename) = m.captures
            # Handle windows-style paths
            filename.tr!('\\', '/')
            @checksums[File.basename(filename).downcase] = checksum
          end
        end
      end

      def checksum_for(filename)
        @checksums[filename]
      end
    end

  end
end
