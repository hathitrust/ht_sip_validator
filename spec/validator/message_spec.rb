# frozen_string_literal: true
require "spec_helper"

module HathiTrust::Validator
  describe Message do
    let(:args) do
      {
        validator: HathiTrust::Validator::Base,
        validation_type: :something,
        human_message: "test fail",
        level: Message::ERROR,
        extras: { a: 1, b: 2 }
      }
    end

    describe "#validation_type" do
      it "accepts a string" do
        message = described_class.new(args.merge(validation_type: "val"))
        expect(message.validation_type).to eql(:val)
      end
      it "accepts a symbol" do
        message = described_class.new(args.merge(validation_type: :some_sym))
        expect(message.validation_type).to eql(:some_sym)
      end
    end
    describe "#validator" do
      it "accepts a class" do
        message = described_class.new(args.merge(validator: Integer))
        expect(message.validator).to eql(Integer)
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
          .to eql("Base - test fail")
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
