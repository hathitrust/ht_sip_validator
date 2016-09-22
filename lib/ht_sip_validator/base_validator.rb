module HathiTrust
  class BaseValidator
    attr_accessor :errors
    attr_accessor :warnings

    def initialize(sip)
      @sip = sip
      @errors = []
      @warnings = []
    end

    def valid?
      true
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
  end
end
