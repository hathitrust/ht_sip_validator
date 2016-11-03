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
    it "accepts an array of validation classes and a logger" do
      validation_class = class_double("DemoValidation", new: double("validation instance"))
      logger = double("a logger")
      expect(described_class.new([validation_class], logger)).to_not be_nil
    end
  end

  describe "#run_validations_on" do
    let(:sip)     { double("a sip") }
    let(:logger)  { TestLogger.new }
    let(:message) { double("a validation message", to_s: "uno\ndos") }
    let(:validation_instance)  { double("a validation", validate: [message]) }
    let(:validation_classes)   do
      [class_double("ValidationOne", new: validation_instance),
       class_double("ValidationTwo", new: validation_instance)]
    end
    let(:validator) { described_class.new(validation_classes, logger) }

    it "runs each validations on the sip" do
      validation_classes.each do |validation|
        expect(validation).to receive(:new).with(sip)
        expect(validation_instance).to receive(:validate)
      end
      validator.run_validations_on sip
    end

    it "logs the class names of each validation" do
      validator.run_validations_on sip
      validation_classes.each do |validation_class|
        expect(logger.logs).to include(a_string_including(validation_class.to_s))
      end
    end

    it "logs the validation errors, adding indenting and preserving newlines" do
      validator.run_validations_on sip
      expect(logger.logs).to include("\tuno\n\tdos")
    end
  end
end
