# frozen_string_literal: true
require "spec_helper"

module HathiTrust
  module Validation
    module MetaYml

      describe WellFormed do
        describe "#validate" do
          context "when meta.yml is well formed" do
            subject(:validator) { described_class.new(SIP::SIP.new(sample_zip("default.zip"))) }

            it_behaves_like "a validator with a valid package"
          end
          context "when meta.yml is not well formed" do
            subject(:validator) do
              described_class.new(SIP::SIP.new(sample_zip("bad_meta_yml.zip")))
            end

            it_behaves_like "a validator with an invalid package"

            it "returns an appropriate error" do
              expect(human_messages(validator.validate))
                .to include(a_string_matching(/Couldn't parse meta.yml/))
            end

            it "has underlying details of the problem" do
              expect(validator.validate.map(&:root_cause))
                .to include(a_string_matching(/ tab /))
            end
          end
        end
      end


    end
  end
end
