require 'ht_sip_validator/base_validator'

module HathiTrust
  module MetaYmlValidators
    # validates that package contains meta.yml
    class ExistsValidator < BaseValidator
      def validate
        @sip.files.include?('meta.yml') ||
          record_and_return_error_message('Package is missing meta.yml')
      end
    end
  end
end
