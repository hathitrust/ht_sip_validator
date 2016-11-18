# frozen_string_literal: true

module HathiTrust::Validator::Package
  class FileBasenames < HathiTrust::Validator::Base

    def perform_validation
      page_content_files(@sip).reject {|filename| is_valid_basename? filename }
        .map do |filename|
        create_error(
          validation_type: :filename_valid,
          human_message: "Base filename of #{filename} is not 8 digits.",
          extras: { filename: filename }
        )
      end
    end

    private

    def page_content_files(sip)
      [:image, :ocr, :coord_ocr].map {|g| sip.group_files(g) }.reduce(:+)
    end

    def is_valid_basename?(filename)
      File.basename(filename, ".*") =~ /^\d{8}$/
    end
  end
end
