# frozen_string_literal: true

module HathiTrust # rubocop:disable Style/ClassAndModuleChildren
  # Representation of configuration for a single Validator
  class ValidatorConfig
    attr_reader :prerequisites
    attr_reader :validator_class

    def initialize(validator_config)
      bad_validator_config(validator_config) unless valid_configuration(validator_config)

      @prerequisites = validator_config.values.first.map do |prereq|
        Validator.const_get(prereq)
      end

      @validator_class = Validator.const_get(validator_config.keys.first)
    end

    private

    def valid_configuration(validator_config)
      validator_config.is_a?(Hash) && (validator_config.size == 1) &&
        validator_config.values.first.is_a?(Array) &&
        validator_config.values.first.all? {|v| v.is_a?(String) }
    end

    def bad_validator_config(validator_config)
      raise ArgumentError, "bad validator specification #{validator_config}:"\
        " should be like 'Validator: [PrerequisiteOne, PrerequisiteTwo, ...]"
    end
  end
end
