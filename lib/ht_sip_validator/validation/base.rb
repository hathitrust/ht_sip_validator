# frozen_string_literal: true
require "ht_sip_validator/validation/messages"

module HathiTrust
  module Validation

    # Interface of validators
    class Base
      def initialize(sip)
        @sip = sip
        @messages = Validation::Messages.new
      end

      def validate
        @messages
      end

      protected

      def record_message(message)
        @messages.push(message)
      end
    end

  end
end
