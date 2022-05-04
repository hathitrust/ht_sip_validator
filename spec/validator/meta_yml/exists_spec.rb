# frozen_string_literal: true

require "spec_helper"

module HathiTrust
  describe Validator::MetaYml::Exists do
    let(:mocked_sip) { SIP::SIP.new("") }

    subject(:validator) { described_class.new(mocked_sip) }

    describe "#validate" do
      context "when meta.yml exists in the package" do
        before(:each) { allow(mocked_sip).to receive(:files).and_return(["meta.yml"]) }
        it_behaves_like "a validator with the correct interface"
        it_behaves_like "a validator with a valid package"
      end

      context "when meta.yml does not exist in the package" do
        before(:each) { allow(mocked_sip).to receive(:files).and_return([]) }

        it_behaves_like "a validator with an invalid package"

        it "returns an appropriate message" do
          expect(human_messages(validator.validate))
            .to include(a_string_matching(/missing meta.yml/))
        end
      end
    end
  end
end
