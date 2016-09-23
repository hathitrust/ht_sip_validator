# frozen_string_literal: true
require "ht_sip_validator/validation/base"

module HathiTrust
  module Validation
    module MetaYml
      # validates that package contains meta.yml
      class Exists < Validation::Base
        def validate
          unless @sip.files.include?("meta.yml")
            @messages << Message.new(
              validator: self.class,
              validation: :exists,
              level: Message::ERROR,
              human_message: 'SIP is missing meta.yml',
              extras: {filename: 'meta.yml'}
            )
          end

          super
        end
      end

      class WellFormed < Validation::Base
        def validate
          begin
            @sip.meta_yml
          rescue RuntimeError => e
            record_message(level: :error, file: 'meta.yml',
                           type: :bad_file,
                           detail: "Couldn't parse meta.yml",
                           root_cause: e.message)
          end

          super

        end
      end
    end
  end
end
