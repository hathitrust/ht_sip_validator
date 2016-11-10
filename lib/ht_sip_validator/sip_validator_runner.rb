# frozen_string_literal: true
require "ht_sip_validator/validator_config"

# Service reponsible for running a set of Validators on a sip
class HathiTrust::SIPValidatorRunner
  # Creates a new validator service using the specified configuration
  def initialize(configuration, logger)
    @validators = configuration
    @logger = logger
  end

  # Validates the given volume and reports any errors
  #
  # @param sip [SubmissionPackage] The volume to validate
  def run_validators_on(sip)
    results = {}
    messages = @validators.map do |validator_config|
      if prereqs_succeeded(validator_config.prerequisites, results)
        run_validator_on(validator_config.validator_class, sip, results)
      else
        skip_validator(validator_config, results)
      end
    end
    messages.reduce(:+)
  end

  private

  def prereqs_succeeded(prerequisites, results)
    prerequisites.all? {|p| results[p] == true }
  end

  def failed_prereqs(prerequisites, results)
    prerequisites.select {|p| results[p] != true }
  end

  def run_validator_on(validator_class, sip, results)
    @logger.info "Running #{validator_class} "

    errors = validator_class.new(sip).validate
    results[validator_class] = validator_success?(errors)
    errors.each {|error| @logger.info "\t" + error.to_s.gsub("\n", "\n\t") }
  end

  def skip_validator(validator_config, results)
    # if prerequisites didn't run
    results[validator_config.validator_class] = :skipped

    message = "Skipping #{validator_config.validator_class}: " +
      failed_prereqs(validator_config.prerequisites, results).map do |p|
        p.to_s + " " + prereq_failure_message(results[p])
      end.join("; ")

    @logger.send(message_error_level(validator_config, results), message)
  end

  def message_error_level(validator_config, results)
    if validator_config.prerequisites.any? {|p| !results.key?(p) }
      :error
    else
      :info
    end
  end

  def prereq_failure_message(result)
    if result == :skipped
      "was skipped"
    elsif result == false
      "failed"
    elsif result.nil?
      "must be run before this validator"
    end
  end

  def validator_success?(messages)
    !messages.any?(&:error?)
  end

end
