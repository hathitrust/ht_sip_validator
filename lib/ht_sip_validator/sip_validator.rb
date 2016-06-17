require 'ht_sip_validator/validations'

module HathiTrust
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
        if validation.run
          puts "PASSED"
        else
          puts "FAILED"
        end
        validation.warnings.each do |warning|
          puts "  Warning: #{warning}"
        end
        validation.errors.each do |error| 
          puts "  Error: #{error}"
        end
      end
    end

  end
end
