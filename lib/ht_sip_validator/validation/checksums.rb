# frozen_string_literal: true
require "ht_sip_validator/validation/base"

module HathiTrust
  module Validation
    module Checksums
      # validates that package contains checksums
      class Exists < HathiTrust::Validation::Base
        def validate
          unless @sip.files.include?(HathiTrust::SIP::CHECKSUM_FILE)
            @messages << Message.new(
              validator: self.class,
              validation: :exists,
              level: Message::ERROR,
              human_message: "SIP is missing #{HathiTrust::SIP::CHECKSUM_FILE}",
              extras: { filename: HathiTrust::SIP::CHECKSUM_FILE }
            )
          end

          super
        end
      end

      # validates that checksums exist for all files in the sip
      class FileListComplete < HathiTrust::Validation::Base
        def validate
          @sip.files.each do |filename|
            next if @sip.checksums.checksum_for(filename)
            @messages << Message.new(
              validator: self.class,
              validation: :file_list_complete,
              level: Message::ERROR,
              human_message: "SIP Checksums is missing checksum for file #{filename}",
              extras: { filename: filename }
            )
          end

          super
        end
      end
    end
  end
end
