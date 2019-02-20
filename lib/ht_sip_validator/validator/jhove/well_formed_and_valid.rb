# frozen_string_literal: true
require "nokogiri"

# frozen_string_literal: true
module HathiTrust::Validator

  # Validates that the image is well-formed and valid
  class JHOVE::WellFormedAndValid < UtilityValidator

    def perform_file_validation(filename, xml)
      status = xml.xpath('./jhove:status',NAMESPACES).text
      if status == 'Well-Formed and valid'
        []
      else
        [
          create_error(
            validation_type: :file_valid,
            human_message: "JHOVE reports #{filename} is #{status}",
            extras: { file: filename }
          )
        ]
      end
    end

    def should_validate?(filename)
      filename =~ /\.(tif|jp2)$/
    end

    private

  end

end
