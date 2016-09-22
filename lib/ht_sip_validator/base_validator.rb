module HathiTrust
  # Base class with utility methods for all validators.
  class BaseValidator
    attr_accessor :errors
    attr_accessor :warnings

    def initialize(sip)
      @sip = sip
      @errors = []
      @warnings = []
      @has_run = false
    end

    def valid?
      return_value = validate
      @has_run = true
      return_value
    end

    def errors
      raise "Can't get errors before validator has run" unless @has_run
      @errors
    end

    def warnings
      raise "Can't get warnings before validator has run" unless @has_run
      @warnings
    end

    private

    def record_and_return_error_message(message)
      @errors.push(message)
      false
    end

    def record_warning_message(message)
      @warnings.push(message)
      true
    end

    def validate
      true
    end
  end
end
