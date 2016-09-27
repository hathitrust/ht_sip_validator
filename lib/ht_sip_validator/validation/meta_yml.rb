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
    end
  end
end
