# frozen_string_literal: true
require "spec_helper"

module HathiTrust

  describe ValidateSIPCommand, integration: true do
    include_context "with test logger"
    include_context "with default zip"
    include_context "with minimal config"
    let(:logger) { TestLogger.new }

    context "filled args" do
      let(:argv) { ["-c", config_file, "-s", zip_file] }
      let(:help_argv) { argv + ["-h"] }

      it "runs the validators" do
        allow(Logger).to receive(:new).and_return(logger)
        expect { described_class.new(argv).exec }.to change { logger.logs }
          .to(["Running #{HathiTrust::Validator::MetaYml::Exists} "])
      end

      it "displays help when given a help flag" do
        allow(Logger).to receive(:new).and_return(logger)
        expect do
          expect { described_class.new(help_argv).exec }.to_not change { logger.logs }
        end.to output(/Show this message/).to_stdout
      end
    end

    context "empty args" do
      let(:argv) { [] }
      let(:help_argv) { argv + ["-h"] }

      it "displays help when given no args" do
        allow(Logger).to receive(:new).and_return(logger)
        expect do
          expect { described_class.new(argv).exec }.to_not change { logger.logs }
        end.to output(/Show this message/).to_stdout
      end

      it "displays help when given a help flag" do
        allow(Logger).to receive(:new).and_return(logger)
        expect do
          expect { described_class.new(help_argv).exec }.to_not change { logger.logs }
        end.to output(/Show this message/).to_stdout
      end
    end
  end

end
