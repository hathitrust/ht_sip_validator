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
      validator = SIPValidatorRunner.new(config, logger(options))
      sip = SIP::SIP.new(options[:sip])
      validator.run_validators_on sip
    end

    private

    def config(config_path)
      File.open(config_path) do |file|
        Configuration.new(file)
      end
    end

    def logger(options)
      logger = Logger.new(STDOUT)
      if options[:verbose]
        logger.level = Logger::INFO
      elsif options[:quiet]
        logger.level = Logger::ERROR
      else
        logger.level = Logger::WARN
      end
        
      logger
    end

    CONFIG_METHODS = [:handle_config_option, :handle_sip_option, :handle_help_option, :handle_verbose_option, :handle_quiet_option].freeze

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

    def handle_verbose_option(opt, options)
      opt.on("-v", "--verbose", "Show verbose output; overrides --quiet") do
        options[:verbose] = true
      end
    end

    def handle_quiet_option(opt, options)
      opt.on("-q", "--quiet", "Show errors only (no warnings)") do
        options[:quiet] = true
      end
    end

  end

end
