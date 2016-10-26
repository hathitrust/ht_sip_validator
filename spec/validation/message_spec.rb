# frozen_string_literal: true
require "spec_helper"

module HathiTrust::Validation
  describe Message do
    let(:args) do
      {
        validator: "MyTest::Validator",
        validation: "first_validation",
        human_message: "test fail",
        level: Message::ERROR,
        extras: { a: 1, b: 2 }
      }
    end

    describe "#validation" do
      it "accepts a string" do
        message = described_class.new(args.merge(validation: "val"))
        expect(message.validation).to eql(:val)
      end
      it "accepts a class" do
        message = described_class.new(args.merge(validation: Integer))
        expect(message.validation).to eql(:Integer)
      end
      it "accepts a symbol" do
        message = described_class.new(args.merge(validation: :some_sym))
        expect(message.validation).to eql(:some_sym)
      end
    end
    describe "#human_message" do
      it "accepts a string" do
        message = described_class.new(args.merge(human_message: "test message"))
        expect(message.human_message).to eql("test message")
      end
    end
    describe "#to_s" do
      it "formats" do
        expect(described_class.new(args).to_s)
          .to eql("ERROR: MyTest::Validator|first_validation - test fail")
      end
    end
    describe "#error?" do
      it "is true if level == Message::ERROR" do
        message = described_class.new(args.merge(level: Message::ERROR))
        expect(message.error?).to be true
      end
      it "is false if level == Message::WARNING" do
        message = described_class.new(args.merge(level: Message::WARNING))
        expect(message.error?).to be false
      end
    end
    describe "#warning?" do
      it "is false if level == Message::ERROR" do
        message = described_class.new(args.merge(level: Message::ERROR))
        expect(message.warning?).to be false
      end
      it "is true if level == Message::WARNING" do
        message = described_class.new(args.merge(level: Message::WARNING))
        expect(message.warning?).to be true
      end
    end
    describe "extras" do
      it "keys are accessible via instance method" do
        message = described_class.new(args.merge(extras: { a: 1, b: 2 }))
        expect(message.a).to eql(1)
        expect(message.b).to eql(2)
      end
      it "throws NoMethodError if the key doesn't exist" do
        expect do
          described_class.new(args).zipzop
        end.to raise_error NoMethodError
      end
    end
  end

end
