# frozen_string_literal: true
module HathiTrust::Validation

  # Output of a validation that fails
  class Message

    ERROR = :error
    WARNING = :warning

    def initialize(validator:, validation:, level:, human_message:, extras: {})
      @validator = validator.to_s.to_sym
      @validation = validation.to_s.to_sym
      @level = level
      @human_message = human_message || validation.to_s
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
      if extras.key?(message)
        extras[message]
      else
        super
      end
    end

    def respond_to_missing?(message, include_private = false)
      extras.key?(message) || super
    end

    def ==(other)
      other.is_a?(self.class) &&
        validator == other.validator &&
        validation == other.validation &&
        level == other.level &&
        human_message == other.human_message &&
        extras == other.extras
    end

    private
    attr_reader :level, :extras

  end

end
