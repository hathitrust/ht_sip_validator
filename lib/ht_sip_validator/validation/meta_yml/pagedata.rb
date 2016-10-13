# frozen_string_literal: true
require "ht_sip_validator/validation/base"
require "set"

module HathiTrust
  module Validation
    module MetaYml
      module PageData

        # Validate that the page data key in meta.yml has the expected keys & values
        class Structure < Validation::Base
          def validate
            if pagedata_present?
              validate_pagedata_keys
              validate_pagedata_values
            end

            super
          end

          private

          def pagedata_present?
            if @sip.meta_yml.key?("pagedata")
              true
            else
              record_warning(
                validation: :field_presence,
                human_message: "'pagedata' is not present in meta.yml; "\
                "users will not have page tags or page numbers to navigate through this book.",
                extras: { filename: "meta.yml",
                          field: "pagedata" }
              )
              false
            end
          end

          def validate_pagedata_keys
            @sip.meta_yml["pagedata"].keys.each do |key|
              # special case for common error of giving a sequence rather than a filename
              if key =~ /^\d{8}$/
                record_error(
                  validation: :field_valid,
                  human_message: "The key #{key} in pagedata in meta.yml appears to refer to a "\
                  "sequence number rather than a filename. Specify the key as #{key}.tif or "\
                  "#{key}.jp2 (as relevant) instead.",
                  extras: { filename: "meta.yml",
                            field: "pagedata",
                            actual: key }
                )
              elsif !key.to_s.match(/^\d{8}.(tif|jp2)$/)
                record_error(
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

          def validate_pagedata_values
            @sip.meta_yml["pagedata"].each do |key, value|
              if value.is_a?(Hash)
                value.keys
                  .select {|k| k != "label" && k != "orderlabel" }
                  .each {|pagedata_key| record_bad_pagedata_value(key, pagedata_key) }
              else
                record_bad_pagedata_value(key, value)
              end
            end
          end

          def record_bad_pagedata_value(key, value)
            record_error(
              validation: :field_valid,
              human_message: "The value #{value} for the pagedata for #{key} is not valid. "\
              " It should be specified as { label: 'pagetag', orderlabel: 'pagenumber' }",
              extras: { filename: "meta.yml",
                        field: "pagedata[#{key}]",
                        actual: value,
                        expected: "{ label: 'pagetag', orderlabel: 'pagenumber' }" }
            )
          end

        end

        # Validate that each file referenced in pagedata refers to a file
        # that's actually in the package.
        class Files < Validation::Base
          def validate
            @sip.meta_yml["pagedata"].keys.to_set.difference(@sip.files).each do |pagefile|
              record_error(
                validation: :file_present,
                human_message: "pagedata in meta.yml references #{pagefile}, but that file "\
                "is not in the package.",
                extras: { filename: pagefile }
              )
            end

            super
          end
        end
      end
    end
  end
end
