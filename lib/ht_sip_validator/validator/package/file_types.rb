require "set"

# frozen_string_literal: true
module HathiTrust::Validator
  VALID_EXTENSIONS = %w[.jp2 .tif .txt .html .xml .yml .pdf .md5].to_set

  # Warn for files with unhandled filename extensions
  class Package::FileTypes < Base
    def perform_validation
      @sip.files.reject { |f| valid_extension?(f) }.map do |filename|
        extension = File.extname(filename)
        create_warning(
          validation_type: :image_filename,
          human_message: "Unexpected file extension #{extension} for #{filename}.",
          extras: {filename: filename,
                   actual: File.extname(filename),
                   expected: VALID_EXTENSIONS}
        )
      end
    end

    private

    def valid_extension?(filename)
      VALID_EXTENSIONS.include?(File.extname(filename))
    end
  end
end
