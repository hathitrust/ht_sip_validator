# frozen_string_literal: true
require "yaml"

module HathiTrust # rubocop:disable Style/ClassAndModuleChildren

  # Represents a validation configuration.
  class Configuration
    attr_reader :config

    def initialize(config_file_handle)
      @config = YAML.load(config_file_handle.read) || {}
    end

    def package_checks
      (config["package_checks"] || [])
        .map {|name| name.sub(/\AValidation::/, "") }
        .map {|name| Validation.const_get(name) }
    end
  end

end
