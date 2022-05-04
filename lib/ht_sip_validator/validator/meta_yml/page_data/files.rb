# frozen_string_literal: true

require "ht_sip_validator/validator/base"
require "set"

module HathiTrust::Validator
  # Validate that each file referenced in pagedata refers to a file
  # that's actually in the package.
  class MetaYml::PageData::Files < Base
    def perform_validation
      @sip.metadata.fetch("pagedata", {}).keys.to_set.difference(@sip.files).map do |pagefile|
        create_warning(
          validation_type: :file_present,
          human_message: "pagedata in meta.yml references #{pagefile}, but that file "\
          "is not in the package.",
          extras: {filename: pagefile}
        )
      end
    end
  end
end
