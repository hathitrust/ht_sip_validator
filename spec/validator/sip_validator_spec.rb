# frozen_string_literal: true

require "spec_helper"

module HathiTrust
  describe SIPValidatorRunner do
    include_context "with stubbed validators"

    describe "#initialize" do
      it "accepts a configuration a logger" do
        validator_config = Configuration.new(StringIO.new(""))
        logger = double("a logger")
        expect(described_class.new(validator_config, logger)).to_not be_nil
      end
    end

    describe "#run_validators_on" do
      let(:sip) { double("a sip") }
      let(:logger) { TestLogger.new }
      let(:package_checks) do
        [ValidatorConfig.new(ValidatorOne: []),
          ValidatorConfig.new(ValidatorTwo: [])]
      end
      let(:file_checks) do
        [ValidatorConfig.new(FileValidatorOne: []),
          ValidatorConfig.new(FileValidatorTwo: [])]
      end
      let(:mocked_config) { Configuration.new(StringIO.new("")) }
      let(:validator) { described_class.new(mocked_config, logger) }
      before(:each) do
        allow(mocked_config).to receive(:package_checks).and_return(package_checks)
        allow(mocked_config).to receive(:file_checks).and_return(file_checks)

        mocked_files = %w[00000001.txt 00000001.tif 00000001.xml 00000002.txt
          00000002.jp2 00000002.xml]

        allow(sip).to receive(:files).and_return(mocked_files)

        # make each_file yield each filename in turn
        mocked_files.map { |name| [name, StringIO.new("")] }
          .reduce(allow(sip).to(receive(:each_file))) { |a, e| a.and_yield(*e) }
      end

      shared_examples_for "a sipvalidator that runs each validator" do
        it "runs each package validator on the sip" do
          package_checks.each do |validator_config|
            expect(validator_config.validator_class).to receive(:new).with(sip)
            expect(validator_instance).to receive(:validate)
          end
          validator.run_validators_on sip
        end

        it "runs each file validator on each file in the sip" do
          sip.files.each do |_file|
            file_checks.each do |validator_config|
              expect(validator_config.validator_class).to receive(:new).with(sip)
              expect(file_validator_instance).to receive(:validate_file)
            end
          end
          validator.run_validators_on sip
        end
      end

      it_behaves_like "a sipvalidator that runs each validator"

      it "logs the class names of each validator" do
        validator.run_validators_on sip
        package_checks.each do |validator_config|
          expect(logger.logs).to include(a_string_including(validator_config.validator_class.to_s))
        end
      end

      it "logs the validator errors, adding indenting and preserving newlines" do
        validator.run_validators_on sip
        expect(logger.logs).to include("uno\n\tdos")
      end

      context "with a configuration listing dependencies" do
        before(:each) do
          class_double("HathiTrust::Validator::AlwaysError",
            new: double("validator that always fails",
              validate: [double("a failure message",
                to_s: "it's an error",
                error?: true, warning?: false)])).as_stubbed_const
        end

        context "when all validators succeed" do
          it_behaves_like "a sipvalidator that runs each validator"
        end

        context "when a validator with a dependency fails" do
          let(:error_package_checks) do
            [ValidatorConfig.new(AlwaysError: []),
              ValidatorConfig.new(ValidatorOne: ["AlwaysError"])]
          end
          let(:error_file_checks) do
            [ValidatorConfig.new(FileValidatorOne: ["AlwaysError"])]
          end
          let(:error_config) { Configuration.new(StringIO.new("")) }
          let(:error_validator) { described_class.new(error_config, logger) }
          before(:each) { allow(error_config).to receive(:package_checks).and_return(error_package_checks) }
          before(:each) { allow(error_config).to receive(:file_checks).and_return(error_file_checks) }

          it "does not run dependent validators" do
            expect(Validator::ValidatorOne).not_to receive(:validate)

            error_validator.run_validators_on(sip)
          end

          it "does not run dependent file validators" do
            expect(Validator::FileValidatorOne).not_to receive(:validate_file)

            error_validator.run_validators_on(sip)
          end

          it "logs skipped validators with the failed dependency" do
            error_validator.run_validators_on(sip)
            # \b for word boundary - ensure there's actually a message for validators
            # we care about - since ValidatorOne is a substring of FileValidatorOne
            expect(logger.logs).to include(
              a_string_matching(/Skipping.*\bValidatorOne\b.*\bAlwaysError\b.*failed/)
            )
            expect(logger.logs).to include(
              a_string_matching(/Skipping.*\bFileValidatorOne\b.*\bAlwaysError\b.*failed/)
            )
          end
        end

        # FIXME DRY
        it "reports appropriately if dependency hasn't been run yet" do
          error_checks = [ValidatorConfig.new(ValidatorOne: ["AlwaysError"])]
          error_config = Configuration.new(StringIO.new(""))
          allow(error_config).to receive(:package_checks).and_return(error_checks)
          error_validator = described_class.new(error_config, logger)

          error_validator.run_validators_on(sip)
          expect(logger.logs).to include(
            a_string_matching(/Skipping.*ValidatorOne.*AlwaysError.*must be run before/)
          )
        end

        it "reports if depdendency was skipped" do
          error_checks = [ValidatorConfig.new(AlwaysError: []),
            ValidatorConfig.new(ValidatorOne: ["AlwaysError"]),
            ValidatorConfig.new(ValidatorTwo: ["ValidatorOne"])]
          error_config = Configuration.new(StringIO.new(""))
          allow(error_config).to receive(:package_checks).and_return(error_checks)
          error_validator = described_class.new(error_config, logger)

          error_validator.run_validators_on(sip)
          expect(logger.logs).to include(
            a_string_matching(/Skipping.*ValidatorTwo.*ValidatorOne.*skipped/)
          )
        end
      end
    end
  end
end
