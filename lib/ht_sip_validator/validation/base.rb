module HathiTrust
  module Validation

    class Base
      def initialize(sip)
        @sip = sip
      end

      def run
        true
      end

      def errors
        []
      end

      def warnings
        []
      end
    end

  end
end
