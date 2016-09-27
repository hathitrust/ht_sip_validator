# frozen_string_literal: true
require "spec_helper"

module HathiTrust
  module Validation
    describe Base do
      subject(:validator) { described_class.new(SIP::SIP.new("")) }

      describe "#validate" do
        it "returns an array" do
          expect(validator.validate).to be_an_instance_of(Array)
        end

        it "does not return any errors" do
          expect(any_errors?(validator.validate)).to be_falsey
        end
      end
    end
  end
end
