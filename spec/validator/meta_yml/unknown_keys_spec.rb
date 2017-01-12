# frozen_string_literal: true
require "spec_helper"

module HathiTrust

  describe Validator::MetaYml::UnknownKeys do
    describe "#validate" do
      include_context "with metadata fixtures"

      let(:mocked_sip) { SIP::SIP.new("") }
      subject(:validator) { described_class.new(mocked_sip) }

      context "when meta.yml has only known keys" do
        before(:each) { allow(mocked_sip).to receive(:metadata) .and_return(valid_metadata) }

        it_behaves_like "a validator with the correct interface"
        it_behaves_like "a validator with a valid package"
        it_behaves_like "a validator that returns no messages"
      end

      context "when meta.yml has an unknown key" do
        before(:each) { allow(mocked_sip).to receive(:metadata) .and_return(invalid_metadata) }

        it_behaves_like "a validator with warnings and only warnings"

        it "returns an appropriate message" do
          expect(human_messages(validator.validate))
            .to include(a_string_matching(/capture_elephant/))
        end
      end
    end
  end

end
