module HathiTrust
  class BaseValidator
    def initialize(sip)
      @sip = sip
    end

    def valid?
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
