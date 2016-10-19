# frozen_string_literal: true
require "ht_sip_validator/validation/base"
require "ht_sip_validator/validation/meta_yml/page_data/files.rb"

module HathiTrust::Validation
  # Validate that the page data key in meta.yml has the expected keys & values
  class MetaYml::PageData::Keys < Base
    def perform_validation
      @sip.meta_yml["pagedata"].keys.map do |key|
        # special case for common error of giving a sequence rather than a filename
        if key =~ /^\d{8}$/
          create_error(
            validation: :field_valid,
            human_message: "The key #{key} in pagedata in meta.yml appears to refer to a "\
            "sequence number rather than a filename. Specify the key as #{key}.tif or "\
            "#{key}.jp2 (as relevant) instead.",
            extras: { filename: "meta.yml",
                      field: "pagedata",
                      actual: key }
          )
        elsif !key.to_s.match(/^\d{8}.(tif|jp2)$/)
          create_error(
            validation: :field_valid,
            human_message: "The key #{key} in pagedata in meta.yml does not refer to a "\
            "validimage filename. Keys in the pagedata should refer to image files, "\
            "which must be named like 00000001.tif or .jp2",
            extras: { filename: "meta.yml",
                      field: "pagedata",
                      actual: key }
          )
        end
      end
    end
  end
end
