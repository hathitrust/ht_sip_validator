module HathiTrust
  module Validation

    # Output of a validation that fails
    class Message

      ERROR = :error
      WARNING = :warning

      def initialize(validator:, validation:, level:, human_message:, extras: {})
        @validator = validator.to_s.to_sym
        @validation = validation.to_s.to_sym
        @level = level
        @human_message = human_message || "#{validator}:#{validation}"
        @extras = extras
      end

      attr_reader :validator, :validation, :human_message

      def error?
        level == :error
      end

      def warning?
        level == :warning
      end

      def to_s
        "#{level.to_s.upcase}: #{validator}|#{validation} - #{human_message}"
      end

      def method_missing(message, *args)
        if extras.has_key?(message)
          extras[message]
        else
          super message, args
        end
      end

      private
      attr_reader :level, :extras

    end

  end
end

