# frozen_string_literal: true
require "spec_helper"

# Stand in class for the Logger
class TestLogger
  attr_accessor :logs
  def info(message)
    self.logs ||= []
    self.logs << message
  end
end

describe HathiTrust::SIPValidatorRunner do
  describe "#initialize" do
    it "accepts an array of validator classes and a logger" do
      validator_class = class_double("DemoValidator", new: double("validator instance"))
      logger = double("a logger")
      expect(described_class.new([validator_class], logger)).to_not be_nil
    end
  end

  describe "#run_validators_on" do
    let(:sip)     { double("a sip") }
    let(:logger)  { TestLogger.new }
    let(:message) { double("a validator message", to_s: "uno\ndos") }
    let(:validator_instance)  { double("a validator", validate: [message]) }
    let(:validator_classes)   do
      [class_double("ValidatorOne", new: validator_instance),
       class_double("ValidatorTwo", new: validator_instance)]
    end
    let(:validator) { described_class.new(validator_classes, logger) }

    it "runs each validators on the sip" do
      validator_classes.each do |validator|
        expect(validator).to receive(:new).with(sip)
        expect(validator_instance).to receive(:validate)
      end
      validator.run_validators_on sip
    end

    it "logs the class names of each validator" do
      validator.run_validators_on sip
      validator_classes.each do |validator_class|
        expect(logger.logs).to include(a_string_including(validator_class.to_s))
      end
    end

    it "logs the validator errors, adding indenting and preserving newlines" do
      validator.run_validators_on sip
      expect(logger.logs).to include("\tuno\n\tdos")
    end
  end
end
