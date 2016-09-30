# frozen_string_literal: true
require "ht_sip_validator/validation/base"

module HathiTrust
  module Validation
    module MetaYml
      # Validates that package contains meta.yml
      class Exists < Validation::Base
        def validate
          unless @sip.files.include?("meta.yml")
            @messages << Message.new(
              validator: self.class,
              validation: :exists,
              level: Message::ERROR,
              human_message: "SIP is missing meta.yml",
              extras: { filename: "meta.yml" }
            )
          end

          super
        end
      end

      # Validates that meta.yml is loadable & parseable
      class WellFormed < Validation::Base
        def validate
          begin
            @sip.meta_yml
          rescue RuntimeError => e
            @messages << Message.new(
              validator: self.class,
              validation: :well_formed,
              level: Message::ERROR,
              human_message: "Couldn't parse meta.yml",
              extras: { filename: "meta.yml",
                        root_cause: e.message }
            )
          end

          super
        end
      end
    end
  end
end
