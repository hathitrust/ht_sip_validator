require "spec_helper"

module HathiTrust
  module Validation



    describe Message do
      let(:args) {{
        validator: "test_validator",
        validation: "first_validation",
        human_message: "test fail",
        level: Message::ERROR,
        extras: { a: 1, b: 2}
      }}

      describe "#validator" do
        it "accepts a string" do
          puts args
          message = described_class.new(args.merge({validator: "val"}))
          expect(message.validator).to eql(:val)
        end
        it "accepts a class" do
          message = described_class.new(args.merge({validator: Fixnum}))
          expect(message.validator).to eql(:Fixnum)
        end
        it "accepts a symbol" do
          message = described_class.new(args.merge({validator: :some_sym}))
          expect(message.validator).to eql(:some_sym)
        end
      end
      describe "#validation" do
        it "accepts a string" do
          message = described_class.new(args.merge({validation: "val"}))
          expect(message.validation).to eql(:val)
        end
        it "accepts a class" do
          message = described_class.new(args.merge({validation: Fixnum}))
          expect(message.validation).to eql(:Fixnum)
        end
        it "accepts a symbol" do
          message = described_class.new(args.merge({validation: :some_sym}))
          expect(message.validation).to eql(:some_sym)
        end
      end
      describe "#human_message" do
        it "accepts a string" do
          message = described_class.new(args.merge({human_message: "test message"}))
          expect(message.human_message).to eql("test message")
        end
      end
      describe "#to_s" do
        it "formats" do
          expect(described_class.new(args).to_s)
            .to eql("ERROR: test_validator|first_validation - test fail")
        end
      end
      describe "#error?" do
        it "is true if level == Message::ERROR" do
          message = described_class.new(args.merge({level: Message::ERROR}))
          expect(message.error?).to be true
        end
        it "is false if level == Message::WARNING" do
          message = described_class.new(args.merge({level: Message::WARNING}))
          expect(message.error?).to be false
        end
      end
      describe "#warning?" do
        it "is false if level == Message::ERROR" do
          message = described_class.new(args.merge({level: Message::ERROR}))
          expect(message.warning?).to be false
        end
        it "is true if level == Message::WARNING" do
          message = described_class.new(args.merge({level: Message::WARNING}))
          expect(message.warning?).to be true
        end
      end
      describe "extras" do
        it "keys are accessible via instance method" do
          message = described_class.new(args.merge(extras: {a: 1, b: 2}))
          expect(message.a).to eql(1)
          expect(message.b).to eql(2)
        end
        it "throws NoMethodError if the key doesn't exist" do
          expect{
            described_class.new(args).zipzop
          }.to raise_error NoMethodError
        end
      end
    end

  end
end