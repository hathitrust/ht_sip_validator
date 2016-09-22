require 'ht_sip_validator/base_validator'

module HathiTrust
  # Driver for running validators from a configuration file on a submission package.
  class SIPValidator
    # Creates a new validator service using the specified configuration
    #
    # @param config [String] path to a YAML file with the validator configuration
    def initialize(config)
      @config = YAML.load(config)
    end

    # Validates the given volume and reports any errors
    #
    # @param sip [SubmissionPackage] The volume to validate
    def validate(sip)
      do_package_checks(sip)
    end

    private

    def do_package_checks(sip)
      @config['package_checks'].each do |validation_name|
        validation = HathiTrust.const_get(validation_name).new(sip)
        print "Running #{validation_name}: "
        if validation.valid?
          puts 'PASSED'
        else
          puts 'FAILED'
        end
        display_messages(validation)
      end
    end

    def display_messages(validation)
      validation.warnings.each do |warning|
        puts "  Warning: #{warning}"
      end
      validation.errors.each do |error|
        puts "  Error: #{error}"
      end
    end
  end
end
