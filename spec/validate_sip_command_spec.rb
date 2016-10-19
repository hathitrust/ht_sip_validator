require "spec_helper"

module HathiTrust

  describe ValidateSIPCommand, integration: true do
    class TestLogger
      attr_accessor :logs, :level
      def info(message)
        self.logs ||= []
        self.logs << message
      end
    end

    include_context "with default zip"
    include_context "with minimal config"
    let(:logger) { TestLogger.new }

    context "filled args" do
      let(:argv) { ["-c", config_file, "-s", zip_file] }
      let(:help_argv) { argv + ["-h"] }

      it "runs the validations" do
        allow(Logger).to receive(:new).and_return(logger)
        expect{ described_class.new(argv).exec }.to change{logger.logs}
          .to(["Running #{HathiTrust::Validation::MetaYml::Exists.to_s} "])
      end

      it "displays help when given a help flag" do
        allow(Logger).to receive(:new).and_return(logger)
        expect{
          expect{ described_class.new(help_argv).exec }.to_not change{logger.logs}
        }.to output(/Show this message/).to_stdout
      end
    end

    context "empty args" do
      let(:argv) { [] }
      let(:help_argv) { argv + ["-h"] }

      it "displays help when given no args" do
        allow(Logger).to receive(:new).and_return(logger)
        expect{
          expect{ described_class.new(argv).exec }.to_not change{logger.logs}
        }.to output(/Show this message/).to_stdout
      end

      it "displays help when given a help flag" do
        allow(Logger).to receive(:new).and_return(logger)
        expect{
          expect{ described_class.new(help_argv).exec }.to_not change{logger.logs}
        }.to output(/Show this message/).to_stdout
      end
    end



  end

end
