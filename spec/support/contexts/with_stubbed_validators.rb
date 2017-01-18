# frozen_string_literal: true
require "spec_helper"

shared_context "with stubbed validators" do
  let(:message) do
    double("a validator message",
      to_s: "uno\ndos",
      error?: false,
      warning?: false)
  end
  let(:validator_instance) { double("a validator", validate: [message]) }
  let(:file_validator_instance) { double("a file validator", validate_file: [message]) }

  before(:each) do
    %w(ValidatorOne ValidatorTwo ValidatorThree).each do |validator|
      class_double("HathiTrust::Validator::#{validator}",
        new: validator_instance).as_stubbed_const
    end
  end

  before(:each) do
    %w(FileValidatorOne FileValidatorTwo).each do |validator|
      class_double("HathiTrust::Validator::#{validator}",
        new: file_validator_instance).as_stubbed_const
    end
  end
end
