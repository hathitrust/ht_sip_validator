# frozen_string_literal: true
require "spec_helper"

describe HathiTrust::Validator::Checksums::Exists do
  let(:mocked_sip) { HathiTrust::SIP::SIP.new("") }
  let(:validator) { described_class.new(mocked_sip) }

  describe "#validate" do
    context "when checksum file exists in the package" do
      before(:each) do
        allow(mocked_sip).to receive(:files)
          .and_return([HathiTrust::SIP::CHECKSUM_FILE])
      end

      it_behaves_like "a validator with a valid package"
      it_behaves_like "a validator that returns no messages"
    end

    context "when checksum file does not exist in the package" do
      before(:each) { allow(mocked_sip).to receive(:files).and_return([]) }

      it_behaves_like "a validator with an invalid package"

      it "returns an appropriate error" do
        expect(human_messages(validator.validate))
          .to include(a_string_matching(/missing #{HathiTrust::SIP::CHECKSUM_FILE}/))
      end
    end
  end
end
