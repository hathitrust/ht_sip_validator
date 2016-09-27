# frozen_string_literal: true

module HathiTrust
  module Validation

    # Interface of validators
    class Base
      def initialize(sip)
        @sip = sip
        @messages = []
      end

      def validate
        @messages
      end
    end

  end
end
