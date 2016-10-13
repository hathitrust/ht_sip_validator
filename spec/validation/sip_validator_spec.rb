# frozen_string_literal: true
require "spec_helper"

# specs for HathiTrust SIP validator service
module HathiTrust
  module Validation

    class TestValidator
      attr_accessor :logs
      def info(message)
        self.logs ||= []
        self.logs << message
      end
    end

    describe SIPValidator do
      describe "#initialize" do
        it "accepts an array of validators and a logger" do
          expect(described_class.new([double(:one)], double(:logger))).to_not be_nil
        end
      end

      describe "#validate" do
        let(:logger) { TestValidator.new }

        it "runs the validators" do
          sip_validator = described_class.new([
            double(:one, new: double(:one_instance, validate: [1])),
            double(:two, new: double(:two_instance, validate: [2]))
          ], logger)
          expect(sip_validator.validate(double(:sip))).to eql([1, 2])
        end

        it "logs the names of validators" do
          validators = [
            double(:one, new: double(:one_instance, validate: [])),
            double(:two, new: double(:two_instance, validate: []))
          ]
          described_class.new(validators, logger).validate(double(:sip))
          expect(logger.logs).to eql(validators.map {|v| "Running #{v} " })
        end

        it "logs the validation errors, preserving newlines and indenting" do
          message = double(:validation_message, to_s: "uno\ndos")
          validation_instance = double(:validation_instance, validate: [message])
          validation_class = double(:validation_class, new: validation_instance)

          described_class.new([validation_class], logger).validate(double(:sip))
          expect(logger.logs[1]).to eql("\tuno\n\tdos")
        end
      end
    end

  end
end
