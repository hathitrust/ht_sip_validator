module HathiTrust
  module Validation
    class Messages < Array
      def any_errors?
        any? { |message| message[:level] == :error }
      end

      def details
        map { |message| message[:detail] }
      end
    end
  end
end
