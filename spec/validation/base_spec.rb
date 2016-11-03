# frozen_string_literal: true
require "spec_helper"

module HathiTrust::Validator
  describe Base do
    class TestBaseValidator < Base
      def initialize(validation_result)
        super("")
        @validation_result = validation_result
      end

      def perform_validation
        @validation_result
      end
    end

    describe "message generation" do
      let(:params) { { validation: "test", human_message: "sdfsdfsda" } }
      let(:validation) { Base.new(double(:sip)) }
      before(:each) do
        # Override the method class to just return its arguments
        allow(HathiTrust::Validator::Message).to receive(:new) {|args| args }
      end

      it "#create_message creates the correct message" do
        expect(validation.create_message(params.merge(level: :test)))
          .to eql(params.merge(level: :test, validation: validation.class))
      end
      it "#create_error creates the correct message" do
        expect(validation.create_error(params))
          .to eql params.merge(level: Message::ERROR, validation: validation.class)
      end
      it "#create_message creates the correct message" do
        expect(validation.create_warning(params))
          .to eql params.merge(level: Message::WARNING, validation: validation.class)
      end
    end

    describe "#validate" do
      let(:validation) { TestBaseValidator.new(validation_result) }
      context "subclass #perform_validation returns nil" do
        let(:validation_result) { nil }
        it "returns an empty array" do
          expect(validation.validate).to eql([])
        end
      end
      context "subclass #perform_validation returns Message" do
        let(:validation_result) { 1 }
        it "returns an array of messages" do
          expect(validation.validate).to eql([1])
        end
      end
      context "subclass #perform_validation returns empty array" do
        let(:validation_result) { [] }
        it "returns an empty array" do
          expect(validation.validate).to eql([])
        end
      end
      context "subclass #perform_validation returns message array" do
        let(:validation_result) { [1, 2] }
        it "returns an empty array" do
          expect(validation.validate).to eql([1, 2])
        end
      end
    end
  end
end
