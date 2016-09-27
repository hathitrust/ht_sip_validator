# frozen_string_literal: true
module HathiTrust
  module Validation

    class Messages < Array
      def any_errors?
        any? { |message| message.error? }
      end

      def human_messages
        map { |message| message.human_message }
      end
    end

  end
end
