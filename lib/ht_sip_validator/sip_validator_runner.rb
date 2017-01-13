# frozen_string_literal: true
require "ht_sip_validator/validator_config"

# Service reponsible for running a set of Validators on a sip
class HathiTrust::SIPValidatorRunner
  # Creates a new validator service using the specified configuration
  def initialize(config, logger)
    @config = config
    @logger = logger
    @error_count = 0
    @warning_count = 0
  end

  # Validates the given volume and reports any errors
  #
  # @param sip [SubmissionPackage] The volume to validate
  def run_validators_on(sip)
    results = {}
    messages = run_package_checks(sip, results)

    sip.each_file do |filename, filehandle|
      messages += run_file_checks(filename, filehandle, sip, results)
    end

    summarize_results(messages)
  end

  private

  def summarize_results(messages)
    flattened_messages = messages.reduce(:+)
    error_count = flattened_messages.select(&:error?).count
    warning_count = flattened_messages.select(&:warning?).count

    status = (error_count.zero? ? "Success" : "Failure")
    puts "#{status}: #{error_count} error(s), #{warning_count} warning(s)"

    flattened_messages
  end

  def run_file_checks(filename, filehandle, sip, results)
    @config.file_checks.map do |validator_config|
      if prereqs_succeeded(validator_config.prerequisites, results)
        run_file_validator_on(validator_config.validator_class, filename, filehandle, sip, results)
      else
        skip_validator(validator_config, results)
      end
    end
  end

  def run_package_checks(sip, results)
    @config.package_checks.map do |validator_config|
      if prereqs_succeeded(validator_config.prerequisites, results)
        run_validator_on(validator_config.validator_class, sip, results)
      else
        skip_validator(validator_config, results)
      end
    end
  end

  def prereqs_succeeded(prerequisites, results)
    prerequisites.all? {|p| results[p] == true }
  end

  def failed_prereqs(prerequisites, results)
    prerequisites.select {|p| results[p] != true }
  end

  def run_file_validator_on(validator_class, filename, filehandle, sip, results)
    @logger.info "Running #{validator_class} on #{filename}"

    # previous check may have left filehandle at EOF.
    filehandle.rewind
    errors = validator_class.new(sip).validate_file(filename, filehandle)
    results[validator_class] = validator_success?(errors)
    errors.each {|error| @logger.public_send(message_level(error), error.to_s.gsub("\n", "\n\t")) }
  end

  def run_validator_on(validator_class, sip, results)
    @logger.info "Running #{validator_class} "

    errors = validator_class.new(sip).validate
    results[validator_class] = validator_success?(errors)
    errors.each {|error| @logger.public_send(message_level(error), error.to_s.gsub("\n", "\n\t")) }
  end

  def skip_validator(validator_config, results)
    # if prerequisites didn't run
    results[validator_config.validator_class] = :skipped

    message = "Skipping #{strip_module(validator_config.validator_class)}: " +
      failed_prereqs(validator_config.prerequisites, results).map do |p|
        strip_module(p).to_s + " " + prereq_failure_message(results[p])
      end.join("; ")

    message_level = skip_validator_message_level(validator_config, results)
    @logger.public_send(message_level, message)

    # return empty array of messages
    []
  end

  def strip_module(klass)
    klass.to_s.sub("HathiTrust::Validator::", "")
  end

  def skip_validator_message_level(validator_config, results)
    # error if there was a prerequisite but it did not run
    if validator_config.prerequisites.any? {|p| !results.key?(p) }
      :error
    else
      :info
    end
  end

  def message_level(message)
    return :error if message.error?
    return :warn if message.warning?
    :info
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
