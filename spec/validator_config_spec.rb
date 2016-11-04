# frozen_string_literal: true
require "spec_helper"

module HathiTrust

  describe ValidatorConfig do
    include_context "with stubbed validators"

    describe "#initialize" do
      it "accepts a string" do
        expect(ValidatorConfig.new("ValidatorOne")).to be_a(ValidatorConfig)
      end
      it "accepts a hash with one key whose value is a string" do
        expect(ValidatorConfig.new("ValidatorOne": "ValidatorTwo"))
          .to be_a(ValidatorConfig)
      end
      it "accepts a hash with one key whose value is an array of strings" do
        expect(ValidatorConfig.new("ValidatorOne": "ValidatorThree"))
          .to be_a(ValidatorConfig)
      end

      it "does not accept a hash with multiple keys" do
        expect do
          ValidatorConfig.new("ValidatorOne": "ValidatorTwo",
                              "ValidatorThree": "ValidatorTwo")
        end.to raise_error(ArgumentError)
      end

      it "does not accept a hash with non-string values" do
        expect { ValidatorConfig.new("ValidatorOne": { "ValidatorTwo": "ValidatorThree" }) }
          .to raise_error(ArgumentError)
      end
    end

    describe "#validator_class" do
      it "returns a class" do
        # don't use one of the stubbed validators
        # because a class double is not a class
        stub_const("HathiTrust::Validator::StubbedValidator", Class.new)
        validator = ValidatorConfig.new("StubbedValidator")
        expect(validator.validator_class).to be_a(Class)
      end
    end

    describe "#prerequisites" do
      context "with no prerequisites" do
        it "returns an empty array" do
          validator = ValidatorConfig.new("ValidatorOne")
          expect(validator.prerequisites).to eql([])
        end
      end

      context "with one prerequisite" do
        it "returns an array with one class" do
          validator = ValidatorConfig.new("ValidatorOne": "ValidatorTwo")
          expect(validator.prerequisites).to eql([HathiTrust::Validator::ValidatorTwo])
        end
      end

      context "with multiple prerequisites" do
        it "returns an array with all the prerequisites" do
          validator = ValidatorConfig.new("ValidatorOne": %w(ValidatorTwo ValidatorThree))
          expect(validator.prerequisites).to eql([HathiTrust::Validator::ValidatorTwo,
                                                  HathiTrust::Validator::ValidatorThree])
        end
      end
    end
  end

end
