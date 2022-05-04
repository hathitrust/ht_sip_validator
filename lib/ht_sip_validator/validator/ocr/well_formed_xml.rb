# frozen_string_literal: true

require "nokogiri"

# frozen_string_literal: true
module HathiTrust::Validator
  # Validates that provided coordinate OCR is UTF-8
  class OCR::WellFormedXML < FileValidator
    def perform_file_validation(filename, filehandle)
      check_well_formed_xml(filename, filehandle)
    end

    def should_validate?(filename)
      !filename.match(/\.(html|xml)$/).nil?
    end

    private

    def check_well_formed_xml(filename, filehandle)
      messages = []
      begin
        Nokogiri::XML(filehandle) do |config|
          # bail out at first sign of a problem
          config.strict.norecover
        end
      rescue Nokogiri::XML::SyntaxError => e
        messages << create_error(
          validation_type: :file_valid,
          human_message: "#{filename} is not well-formed XML: #{e}",
          extras: {file: filename}
        )
      end
      messages
    end
  end
end
