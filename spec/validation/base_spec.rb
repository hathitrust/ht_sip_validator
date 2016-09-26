# frozen_string_literal: true
require "spec_helper"
require "ht_sip_validator/validation/base"

module HathiTrust
  module Validation
    describe Base do
      subject(:validator) { described_class.new(SIP::SIP.new("")) }

      describe "#validate" do
        it "returns HathiTrust::Validation::Messages" do
          expect(validator.validate).to be_an_instance_of(Validation::Messages)
        end

        it "does not return any errors" do
          expect(validator.validate.any_errors?).to be_falsey
        end
      end
    end
  end
end
