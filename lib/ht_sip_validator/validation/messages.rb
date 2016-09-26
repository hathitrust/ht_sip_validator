# frozen_string_literal: true
module HathiTrust
  module Validation

    # A collection of messages
    class Messages < Array
      def any_errors?
        any? {|message| message[:level] == :error }
      end

      def details
        map {|message| message[:detail] }
      end
    end

  end
end
