# frozen_string_literal: true
# Service reponsible for running a set of Validators on a sip
class HathiTrust::SIPValidatorRunner
  # Creates a new validator service using the specified configuration
  def initialize(validators, logger)
    @validators = validators
    @logger = logger
  end

  # Validates the given volume and reports any errors
  #
  # @param sip [SubmissionPackage] The volume to validate
  def run_validators_on(sip)
    messages = @validators.map do |validator_class|
      @logger.info "Running #{validator_class} "
      errors = validator_class.new(sip).validate
      errors.each {|error| @logger.info "\t" + error.to_s.gsub("\n", "\n\t") }
    end
    messages.reduce(:+)
  end
end
