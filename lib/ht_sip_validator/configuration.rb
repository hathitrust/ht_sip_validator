# frozen_string_literal: true
require "yaml"
require "ht_sip_validator/validator_config"

module HathiTrust # rubocop:disable Style/ClassAndModuleChildren

  # Represents a configuration for a set of Validators
  class Configuration
    attr_reader :config

    def initialize(config_file_handle)
      @config = YAML.load(config_file_handle.read) || {}
    end

    def package_checks
      config_section_checks("package_checks")
    end

    def file_checks
      config_section_checks("file_checks")
    end

    private

    def config_section_checks(type)
      (config[type] || [])
        .map {|config| ValidatorConfig.new(config) }
    end
  end

end
