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

      protected

      def record_message(params = {})
        @messages << Message.new(params.merge(validator: self.class))
      end

      def record_error(params = {})
        record_message(params.merge(level: Message::ERROR))
      end

      def record_warning(params = {})
        record_message(params.merge(level: Message::WARNING))
      end

    end

  end
end
