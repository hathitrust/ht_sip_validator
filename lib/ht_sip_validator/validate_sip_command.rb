require "ht_sip_validator/configuration"
require "ht_sip_validator/validation/sip_validator"
require "logger"
require "optparse"

module HathiTrust

  class ValidateSIPCommand
    def initialize(argv)
      @argv = argv
    end

    def exec
      options = parse(@argv)
      return if options[:quit]
      raise ArgumentError unless options[:config] && options[:sip]
      config = config(options[:config])
      validator = HathiTrust::Validation::SIPValidator.new(config.package_checks, logger)
      sip = HathiTrust::SIP::SIP.new(options[:sip])
      validator.run_validations_on sip
    end


    private
    def config(config_path)
      File.open(config_path) do |file|
        HathiTrust::Configuration.new(file)
      end
    end

    def logger
      logger = Logger.new(STDOUT)
      logger.level = Logger::INFO
      return logger
    end

    def parse(argv)
      argv.push("-h") if argv.empty?
      options = {}
      OptionParser.new do |opt|
        opt.banner = "Usage: validate_sip [options]"
        opt.on "-c", "--config=CONFIGPATH",
          "Path to the configuration." do |location|
          options[:config] = location
        end
        opt.on "-s", "--sip=SIP",
          "Path to the sip." do |location|
          options[:sip] = location
        end
        opt.on_tail("-h", "--help", "Show this message") do
          puts opt
          options[:quit] = true
        end
      end.parse!(argv)
      return options
    end

  end

end

