# frozen_string_literal: true
require "ht_sip_validator/configuration"
require "ht_sip_validator/sip_validator_runner"
require "logger"
require "optparse"

module HathiTrust # rubocop:disable Style/ClassAndModuleChildren

  # driver for handling command line options and validating a SIP
  class ValidateSIPCommand
    def initialize(argv)
      @argv = argv
    end

    def exec
      options = parse(@argv)
      return if options[:quit]
      raise ArgumentError unless options[:config] && options[:sip]
      config = config(options[:config])
      validator = SIPValidatorRunner.new(config.package_checks, logger)
      sip = SIP::SIP.new(options[:sip])
      validator.run_validators_on sip
    end

    private

    def config(config_path)
      File.open(config_path) do |file|
        Configuration.new(file)
      end
    end

    def logger
      logger = Logger.new(STDOUT)
      logger.level = Logger::INFO
      logger
    end

    CONFIG_METHODS = [:handle_config_option, :handle_sip_option, :handle_help_option].freeze

    def parse(argv)
      argv.push("-h") if argv.empty?
      options = {}
      OptionParser.new do |opt|
        opt.banner = "Usage: validate_sip [options]"
        CONFIG_METHODS.each {|m| send(m, opt, options) }
      end.parse!(argv)
      options
    end

    def handle_config_option(opt, options)
      opt.on "-c", "--config=CONFIGPATH",
        "Path to the configuration." do |location|
        options[:config] = location
      end
    end

    def handle_sip_option(opt, options)
      opt.on "-s", "--sip=SIP",
        "Path to the sip." do |location|
        options[:sip] = location
      end
    end

    def handle_help_option(opt, options)
      opt.on_tail("-h", "--help", "Show this message") do
        puts opt
        options[:quit] = true
      end
    end

  end

end
