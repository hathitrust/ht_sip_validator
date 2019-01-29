# frozen_string_literal: true
require "ht_sip_validator/configuration"
require "ht_sip_validator/sip_validator_runner"
require "logger"
require "optparse"

module HathiTrust

  class ValidateSIPLogFormatter < Logger::Formatter
    def initialize(sip)
      super()
      @sip = sip
      @counts = {}
    end

    def call(severity, _timestamp, _progname, msg)
      "#{File.basename(@sip)} - #{severity}: #{msg}\n"
    end
  end

  # driver for handling command line options and validating a SIP
  class ValidateSIPCommand
    def initialize(argv)
      @argv = argv
    end

    def exec
      (options, sip_filenames) = parse(@argv)
      return if options[:quit]
      config = config(options[:config] || default_config)

      sip_filenames.each do |sip_filename|
        validator = SIPValidatorRunner.new(config, logger(options,sip_filename))
        sip = SIP::SIP.new(sip_filename)
        summarize_results(sip_filename,validator.run_validators_on(sip))
      end
    end

    private

    def default_config
      Pathname.new("#{File.dirname(__FILE__)}/../../config/default.yml").to_s
    end

    def summarize_results(sip_filename,messages)
      error_count = messages.select(&:error?).count
      warning_count = messages.select(&:warning?).count

      status = (error_count.zero? ? "Success" : "Failure")
      puts "#{File.basename(sip_filename)} - #{status}: #{error_count} error(s), #{warning_count} warning(s)"
    end

    def config(config_path)
      File.open(config_path) do |file|
        Configuration.new(file)
      end
    end

    def logger(options,sip_filename)
      logger = Logger.new(STDOUT)
      logger.level = if options[:verbose]
                       Logger::INFO
                     elsif options[:quiet]
                       Logger::ERROR
                     else
                       Logger::WARN
      end

      logger.formatter = ValidateSIPLogFormatter.new(sip_filename)

      logger
    end

    CONFIG_METHODS = [:handle_config_option, :handle_help_option, :handle_verbose_option, :handle_quiet_option].freeze

    def parse(argv)
      argv.push("-h") if argv.empty?
      options = {}
      OptionParser.new do |opt|
        opt.banner = "Usage: validate_sip [options]"
        CONFIG_METHODS.each {|m| send(m, opt, options) }
      end.parse!(argv)
      [options, argv]
    end

    def handle_config_option(opt, options)
      opt.on "-c", "--config=CONFIGPATH",
        "Path to the configuration." do |location|
        options[:config] = location
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
