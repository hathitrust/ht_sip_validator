# frozen_string_literal: true

require "ht_sip_validator/validator/base"

module HathiTrust::Validator
  # Validate that all page tags are in the allowed set.
  class MetaYml::PageData::PageTags < Base
    ALLOWED_PAGETAGS = %w[BACK_COVER BLANK CHAPTER_PAGE CHAPTER_START COPYRIGHT
      FIRST_CONTENT_CHAPTER_START FOLDOUT FRONT_COVER IMAGE_ON_PAGE INDEX
      MISSING MULTIWORK_BOUNDARY PREFACE REFERENCES TABLE_OF_CONTENTS
      TITLE TITLE_PARTS].to_set

    def perform_validation
      @sip.metadata.fetch("pagedata", {}).map do |filename, pageinfo|
        pageinfo.fetch("label", "").split(/,\s*/).to_set
          .difference(ALLOWED_PAGETAGS).map do |bad_pagetag|
          create_error(
            validation_type: :field_valid,
            human_message: "Unknown page tag #{bad_pagetag} for file #{filename}",
            extras: {filename: "meta.yml",
                     field: "pagedata[#{filename}][label]",
                     actual: bad_pagetag}
          )
        end
      end
    end
  end
end
