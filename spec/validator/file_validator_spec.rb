# frozen_string_literal: true

require "spec_helper"

module HathiTrust::Validator
  GOOD_NAME = "good.txt"
  BAD_NAME = "junk.txt"

  class TestFileValidator < FileValidator
    def initialize(validator_result)
      super("")
      @validator_result = validator_result
    end

    def perform_file_validation(_name, _handle)
      @validator_result
    end

    def should_validate?(name)
      name == GOOD_NAME
    end
  end

  describe FileValidator do
    describe "#validate_file" do
      let(:validator) { TestFileValidator.new(validator_result) }
      context "subclass #perform_validation returns Message if file is relevant" do
        let(:validator_result) { 1 }
        it "returns an array of messages" do
          expect(validator.validate_file(GOOD_NAME, nil)).to eql([1])
        end
      end
      context "subclass #perform_validation returns empty array if file is not relevant" do
        let(:validator_result) { [] }
        it "returns an empty array" do
          expect(validator.validate_file(BAD_NAME, nil)).to eql([])
        end
      end
    end
  end
end
