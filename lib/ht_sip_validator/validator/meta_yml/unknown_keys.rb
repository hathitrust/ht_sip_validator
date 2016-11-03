# frozen_string_literal: true
require "ht_sip_validator/validator/base"

module HathiTrust::Validator
  # Warns if meta.yml has any unexpected keys
  class MetaYml::UnknownKeys < Base
    require "set"
    KNOWN_KEYS = %w(capture_date scanner_make scanner_model scanner_user
                    creation_date creation_agent digital_content_provider tiff_artist
                    bitonal_resolution_dpi contone_resolution_dpi image_compression_date
                    image_compression_agent image_compression_tool scanning_order
                    reading_order pagedata).to_set

    def perform_validation
      @sip.meta_yml.keys.to_set.difference(KNOWN_KEYS).map do |key|
        create_warning(
          validation: :field_valid,
          human_message: "Unknown key #{key} in meta.yml",
          extras: { filename: "meta.yml",
                    field: key }
        )
      end
    end
  end
end
