# frozen_string_literal: true
module HathiTrust
  module Validation

    # Service reponsible for validating a sip
    class SIPValidator
      # Creates a new validator service using the specified configuration
      def initialize(validators, logger)
        @validators = validators
        @logger = logger
      end

      # Validates the given volume and reports any errors
      #
      # @param sip [SubmissionPackage] The volume to validate
      def validate(sip)
        messages = @validators.map do |validation_class|
          @logger.info "Running #{validation_class} "
          errors = validation_class.new(sip).validate
          errors.each {|error| @logger.info "\t" + error.to_s.gsub("\n", "\n\t") }
        end
        messages.reduce(:+)
      end

    end

  end
end
