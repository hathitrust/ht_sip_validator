# frozen_string_literal: true
require "spec_helper"

module HathiTrust
  describe SIPValidatorRunner do
    include_context "with stubbed validators"

    describe "#initialize" do
      it "accepts an array of validator configurations and a logger" do
        validator_config = ValidatorConfig.new("ValidatorOne")
        logger = double("a logger")
        expect(described_class.new([validator_config], logger)).to_not be_nil
      end
    end

    describe "#run_validators_on" do
      include_context "with test logger"
      let(:sip)     { double("a sip") }
      let(:logger)  { TestLogger.new }
      let(:config) do
        [ValidatorConfig.new("ValidatorOne"),
         ValidatorConfig.new("ValidatorTwo")]
      end
      let(:validator) { described_class.new(config, logger) }

      shared_examples_for "a sipvalidator that runs each validator" do
        it "runs each validator on the sip" do
          config.each do |validator_config|
            expect(validator_config.validator_class).to receive(:new).with(sip)
            expect(validator_instance).to receive(:validate)
          end
          validator.run_validators_on sip
        end
      end

      it_behaves_like "a sipvalidator that runs each validator"

      it "logs the class names of each validator" do
        validator.run_validators_on sip
        config.each do |validator_config|
          expect(logger.logs).to include(a_string_including(validator_config.validator_class.to_s))
        end
      end

      it "logs the validator errors, adding indenting and preserving newlines" do
        validator.run_validators_on sip
        expect(logger.logs).to include("\tuno\n\tdos")
      end

      context "with a configuration listing dependencies" do
        before(:each) do
          class_double("HathiTrust::Validator::AlwaysError",
            new: double("validator that always fails",
              validate: [double("a failure message",
                to_s: "it's an error",
                error?: true)])).as_stubbed_const
        end

        context "when all validators succeed" do
          it_behaves_like "a sipvalidator that runs each validator"
        end

        context "when a validator with a dependency fails" do
          let(:error_config) do
            [ValidatorConfig.new("AlwaysError"),
             ValidatorConfig.new("ValidatorOne": "AlwaysError")]
          end
          let(:error_validator) { described_class.new(error_config, logger) }

          it "does not run dependent validators" do
            expect(Validator::ValidatorOne).not_to receive(:validate)

            error_validator.run_validators_on(sip)
          end

          it "logs skipped validators with the failed dependency" do
            error_validator.run_validators_on(sip)
            expect(logger.logs).to include(
              a_string_matching(/Skipping.*ValidatorOne.*AlwaysError.*failed/)
            )
          end
        end

        it "reports appropriately if dependency hasn't been run yet" do
          error_config = [ValidatorConfig.new("ValidatorOne": "AlwaysError")]
          error_validator = described_class.new(error_config, logger)

          error_validator.run_validators_on(sip)
          expect(logger.logs).to include(
            a_string_matching(/Skipping.*ValidatorOne.*AlwaysError.*must be run before/)
          )
        end

        it "reports if depdendency was skipped" do
          error_config = [ValidatorConfig.new("AlwaysError"),
                          ValidatorConfig.new("ValidatorOne": "AlwaysError"),
                          ValidatorConfig.new("ValidatorTwo": "ValidatorOne")]
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
