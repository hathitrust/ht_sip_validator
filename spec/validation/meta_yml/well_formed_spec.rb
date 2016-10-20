# frozen_string_literal: true
require "spec_helper"

module HathiTrust
  describe Validation::MetaYml::WellFormed do
    describe "#validate" do
      context "when meta.yml is well formed" do
        subject(:validation) { described_class.new(SIP::SIP.new(sample_zip("default.zip"))) }
        it_behaves_like "a validation with the correct interface"
        it_behaves_like "a validation with a valid package"
      end
      context "when meta.yml is not well formed" do
        subject(:validation) do
          described_class.new(SIP::SIP.new(sample_zip("bad_meta_yml.zip")))
        end

        it_behaves_like "a validation with an invalid package"

        it "returns an appropriate message" do
          expect(human_messages(validation.validate))
            .to include(a_string_matching(/Couldn't parse meta.yml/))
        end

        it "has underlying details of the problem" do
          expect(validation.validate.map(&:root_cause))
            .to include(a_string_matching(/ tab /))
        end
      end
    end
  end
end
