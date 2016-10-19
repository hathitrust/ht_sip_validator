# frozen_string_literal: true

module HathiTrust::Validation

  # Interface of validators
  class Base
    attr_reader :sip

    # @param [SIP::SIP] sip
    def initialize(sip)
      @sip = sip
    end

    # Performs the validation and returns the error
    # messages.
    # @return [Array<Message>] Empty if no errors were
    #   found.
    def validate
      [perform_validation].flatten.reject{|i| i.nil? }
    end


    # Actual work of performing the validation
    # @return [Array<Message>|Message|nil]
    def perform_validation
      raise NotImplementedError
    end


    def create_message(params)
      Message.new(params.merge(validation: self.class))
    end

    def create_error(params)
      create_message(params.merge(level: Message::ERROR))
    end

    def create_warning(params)
      create_message(params.merge(level: Message::WARNING))
    end

  end

end
