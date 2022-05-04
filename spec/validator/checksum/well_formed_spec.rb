# frozen_string_literal: true

require "spec_helper"

describe HathiTrust::Validator::Checksums::WellFormed do
  let(:mocked_sip) { instance_double("HathiTrust::SIP::SIP") }
  let(:exempt_filenames) { HathiTrust::Validator::Checksums::EXEMPT_FILENAMES }
  let(:mock_checksums) { instance_double("HathiTrust::SIP::Checksums") }
  let(:validator) { described_class.new(mocked_sip) }

  before(:each) { allow(mocked_sip).to receive(:checksums).and_return(mock_checksums) }
  before(:each) { allow(mock_checksums).to receive(:checksums).and_return(checksums_hash) }

  context "with well formed checksums" do
    let(:checksums_hash) do
      {filename1: "b0ee419150085f64ef8311dc3919d1a3",
       filename2: "d2e0dceff9e2e8bce3ec82a9760f4f61",
       filename3: "24f9133e5b40ef61a1879df2a6de8a48"}
    end

    it_behaves_like "a validator with a valid package"
    it_behaves_like "a validator that returns no messages"
  end

  context "with malformed checksums" do
    let(:checksums_hash) do
      {filename1: "deadbeefdeadbeefdeadbeefdeadbeefdeadbeef",
       filename2: "deadbeefdeadbeefdeadbeef",
       filename3: "qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq",
       filename4: "-*//$&^fffffffffffffffffffffffff"}
    end

    it_behaves_like "a validator with an invalid package"

    it "generates an error message for each checksum value." do
      returned_messages = validator.validate
      expect(returned_messages.count).to eq(checksums_hash.count)
      expect(returned_messages.all?(&:error?)).to be true
    end

    it "generates error messages that indicate the bad value." do
      checksums_hash.each do |_filename, bad_value|
        expect(human_messages(validator.validate)).to include(a_string_including(bad_value))
      end
    end
  end
end
