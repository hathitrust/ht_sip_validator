require 'ht_sip_validator/validation/base'

module HathiTrust
  module Validation
    module MetaYml
      # validates that package contains meta.yml
      class Exists < Validation::Base
        def validate
          unless @sip.files.include?('meta.yml')
            record_message(level: :error, file: 'meta.yml',
                           type: :file_missing,
                           detail: 'SIP is missing meta.yml')
          end

          super
        end
      end
    end
  end
end
