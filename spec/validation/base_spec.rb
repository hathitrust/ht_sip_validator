# frozen_string_literal: true
require "spec_helper"

module HathiTrust
  module Validation
    describe Base do

      class TestBaseValidator < Base
        def initialize(validation_result)
          super("")
          @validtion_result = validation_result
        end
        def perform_validation
          @validtion_result
        end
      end


      describe "message generation" do
        let(:params) { {validation: "test", human_message: "sdfsdfsda" } }
        let(:validator) { Base.new(double(:sip)) }
        before(:each) do
          # Override the method class to just return its arguments
          allow(HathiTrust::Validation::Message).to receive(:new) {|args| args }
        end

        it "#create_message creates the correct message" do
          expect(validator.create_message(params.merge({level: :test})))
            .to eql(params.merge(level: :test, validator: validator.class))
        end
        it "#create_error creates the correct message" do
          expect(validator.create_error(params))
            .to eql params.merge(level: Message::ERROR, validator: validator.class)
        end
        it "#create_message creates the correct message" do
          expect(validator.create_warning(params))
            .to eql params.merge(level: Message::WARNING, validator: validator.class)
        end
      end

      describe "#validate" do
        let(:validator) { TestBaseValidator.new(validation_result)}
        context "subclass #perform_validation returns nil" do
          let(:validation_result) { nil }
          it "returns an empty array" do
            expect(validator.validate).to eql([])
          end
        end
        context "subclass #perform_validation returns Message" do
          let(:validation_result) { 1 }
          it "returns an array of messages" do
            expect(validator.validate).to eql([1])
          end
        end
        context "subclass #perform_validation returns empty array" do
          let(:validation_result) { [] }
          it "returns an empty array" do
            expect(validator.validate).to eql([])
          end
        end
        context "subclass #perform_validation returns message array" do
          let(:validation_result) { [1,2] }
          it "returns an empty array" do
            expect(validator.validate).to eql([1,2])
          end
        end
      end


    end
  end
end
