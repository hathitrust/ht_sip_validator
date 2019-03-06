# frozen_string_literal: true
require "spec_helper"

module HathiTrust

  describe ValidateSIPCommand, integration: true do
    describe "argument parsing" do
      include_context "with minimal config"
      include_context "with default zip"
      include_context "with test logger"
      let(:logger) { TestLogger.new }
      before(:each) { allow(Logger).to receive(:new).and_return(logger) }

      context "filled args" do
        let(:argv) { ["-c", config_file, zip_file] }
        let(:help_argv) { argv + ["-h"] }

        it "runs the validators" do
          expect { described_class.new(argv).exec }.to change { logger.logs }
            .to(["Running #{HathiTrust::Validator::MetaYml::Exists} "])
        end

        it "displays help when given a help flag" do
          expect do
            expect { described_class.new(help_argv).exec }.to_not change { logger.logs }
          end.to output(/Show this message/).to_stdout
        end
      end

      context "empty args" do
        let(:argv) { [] }
        let(:help_argv) { argv + ["-h"] }

        it "displays help when given no args" do
          expect do
            expect { described_class.new(argv).exec }.to_not change { logger.logs }
          end.to output(/Show this message/).to_stdout
        end

        it "displays help when given a help flag" do
          expect do
            expect { described_class.new(help_argv).exec }.to_not change { logger.logs }
          end.to output(/Show this message/).to_stdout
        end
      end
    end

    describe "full integration test" do
      context "valid sip" do
        let(:zip_file) { File.join fixtures_path, "sips", "no_warnings.zip" }
        let(:argv) { [zip_file] }

        it "has no warnings or errors" do
          expect do
            described_class.new(argv).exec
          end.to output(/Success: 0 error\(s\), 0 warning\(s\)/).to_stdout
        end
      end

      context "sip with checksums from powershell" do
        let(:zip_file) { File.join fixtures_path, "sips", "powershell_checksums.zip" }
        let(:argv) { [zip_file] }

        it "has no warnings or errors" do
          expect do
            described_class.new(argv).exec
          end.to output(/Success: 0 error\(s\), 0 warning\(s\)/).to_stdout
        end
      end

      context "invalid sip" do
        let(:zip_file) { File.join fixtures_path, "sips", "bad_ocr.zip" }
        let(:argv) { [zip_file] }

        it "has the expected errors" do
          expect do
            described_class.new(argv).exec
          end.to output(/ERROR: OCR::UTF8 - File 00000002.txt is not valid UTF-8/).to_stdout_from_any_process
        end

        it "outputs a summary" do
          expect do
            described_class.new(argv).exec
          end.to output(/Failure: 2 error\(s\), 4 warning\(s\)/).to_stdout
        end
      end
    end
  end

end
