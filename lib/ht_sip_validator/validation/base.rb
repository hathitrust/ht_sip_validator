module HathiTrust
  module Validation
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
