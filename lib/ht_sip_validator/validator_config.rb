# frozen_string_literal: true

module HathiTrust # rubocop:disable Style/ClassAndModuleChildren
  # Representation of configuration for a single Validator
  class ValidatorConfig
    attr_reader :prerequisites
    attr_reader :validator_class

    def initialize(validator_config)
      @prerequisites = parse_prerequisites(validator_config).map do |prereq|
        Validator.const_get(prereq)
      end

      @validator_class = Validator.const_get(parse_validator_class(validator_config))
    end

    private

    def no_prereqs?(validator_config)
      validator_config.is_a?(String)
    end

    def one_prerequisite?(validator_config)
      validator_config.is_a?(Hash) && (validator_config.size == 1) &&
        validator_config.values.first.is_a?(String)
    end

    def multi_prerequisites?(validator_config)
      validator_config.is_a?(Hash) && (validator_config.size == 1) &&
        validator_config.values.first.is_a?(Array) &&
        validator_config.values.first.all? {|v| v.is_a?(String) }
    end

    def parse_prerequisites(validator_config)
      if no_prereqs?(validator_config)
        []
      elsif one_prerequisite?(validator_config)
        [validator_config.values.first]
      elsif multi_prerequisites?(validator_config)
        validator_config.values.first
      else
        bad_validator_config(validator_config)
      end
    end

    def parse_validator_class(validator_config)
      if no_prereqs?(validator_config)
        validator_config
      elsif one_prerequisite?(validator_config) ||
          multi_prerequisites?(validator_config)
        validator_config.keys.first
      else
        bad_validator_config(validator_config)
      end
    end

    def bad_validator_config(validator_config)
      raise ArgumentError, "bad validator specification #{validator_config}:"\
        " should be like 'Validator', 'Validator: PrerequisiteValidator',"\
        " or 'Validator: [PrereqOne, PrereqTwo, ...]"
    end
  end
end
