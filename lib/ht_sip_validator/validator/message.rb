# frozen_string_literal: true
module HathiTrust::Validator

  # Output of a validator that fails
  class Message

    ERROR = :error
    WARNING = :warning

    def initialize(validator:, validation_type:, level:, human_message:, extras: {})
      @extras = extras
      @validator = validator
      @validation_type = validation_type.to_s.to_sym
      @level = level
      @human_message = human_message || validation_type.to_s
    end

    attr_reader :validation_type, :human_message, :validator

    def error?
      level == :error
    end

    def warning?
      level == :warning
    end

    def to_s
      "#{level.to_s.upcase}: "\
        "#{validator.to_s.sub("HathiTrust::Validator::", "")}"\
        " - #{human_message}"
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
      if other.class == Array
        binding.pry
      end
      error? == other.error? &&
        validator == other.validator &&
        validation_type == other.validation_type &&
        human_message == other.human_message
    end
    alias_method :equal?, :==
    alias_method :eql?, :==

    private

    attr_reader :level, :extras

  end

end
