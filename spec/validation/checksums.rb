# frozen_string_literal: true
require "spec_helper"
require_relative "../../lib/ht_sip_validator/sip/sip"
require_relative "../../lib/ht_sip_validator/validation/checksums"

describe HathiTrust::Validation::Checksums::Exists do
  let(:mocked_sip) { HathiTrust::SIP::SIP.new("") }
  let(:validation) { described_class.new(mocked_sip) }

  describe "#validate" do
    context "when checksum file exists in the package" do
      before(:each) { allow(mocked_sip).to receive(:files).and_return([HathiTrust::SIP::CHECKSUM_FILE]) }

      it "does not return any messages" do
        returned_messages = validation.validate
        expect(returned_messages).to be_empty
      end
    end
    context "when checksum file does not exist in the package" do
      before(:each) { allow(mocked_sip).to receive(:files).and_return([]) }

      it "returns an appropriate error" do
        returned_messages = validation.validate
        expect(returned_messages.count).to equal(1)
        expect(any_errors?(returned_messages)).to be true
        expect(returned_messages.first.human_message).to match(/missing #{HathiTrust::SIP::CHECKSUM_FILE}/)
      end
    end
  end
end

describe HathiTrust::Validation::Checksums::FileListComplete do
  let(:mocked_sip) { HathiTrust::SIP::SIP.new("") }
  let(:mock_checksums) { instance_double("HathiTrust::SIP::Checksums") }
  let(:validation) { described_class.new(mocked_sip) }

  describe "#validate" do
    context "when checksums filenames match sip files." do
      let(:file_list) { %w(foo bar baz) }
      before(:each) { allow(mocked_sip).to receive(:files).and_return(file_list) }
      before(:each) { allow(mocked_sip).to receive(:checksums).and_return(mock_checksums) }
      before(:each) { allow(mock_checksums).to receive(:checksum_for) {|arg| arg } }

      it "does not return any messages" do
        returned_messages = validation.validate
        expect(returned_messages).to be_empty
      end
    end
    context "when checksums filenames are not in sip files." do
      let(:file_list) { %w(foo bar baz) }
      before(:each) { allow(mocked_sip).to receive(:files).and_return(file_list) }
      before(:each) { allow(mocked_sip).to receive(:checksums).and_return(mock_checksums) }
      before(:each) { allow(mock_checksums).to receive(:checksum_for).and_return(nil) }

      it "generates an error message for each missing filename." do
        returned_messages = validation.validate
        expect(returned_messages.count).to eq(file_list.count)
        expect(returned_messages.all?(&:error?)).to be true
      end
    end
  end
end
