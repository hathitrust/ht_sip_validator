# frozen_string_literal: true
require "spec_helper"

describe HathiTrust::Validator::Checksums::FileListComplete do
  let(:mocked_sip) { HathiTrust::SIP::SIP.new("") }
  let(:exempt_filenames) { HathiTrust::Validator::Checksums::EXEMPT_FILENAMES }
  let(:mock_checksums) { instance_double("HathiTrust::SIP::Checksums") }
  let(:validator) { described_class.new(mocked_sip) }

  before(:each) { allow(mocked_sip).to receive(:files).and_return(file_list) }
  before(:each) { allow(mocked_sip).to receive(:checksums).and_return(mock_checksums) }

  describe "#validate" do
    context "when checksums filenames match sip files." do
      let(:file_list) { %w(foo bar baz) }
      before(:each) { allow(mock_checksums).to receive(:checksum_for) {|arg| arg } }

      it_behaves_like "a validator with a valid package"
      it_behaves_like "a validator that returns no messages"
    end

    context "when sip files include checksum exempt filenames." do
      let(:file_list) { %w(foo bar baz) + exempt_filenames }
      before(:each) { allow(mock_checksums).to receive(:checksum_for) {|arg| arg } }

      it_behaves_like "a validator with a valid package"
      it_behaves_like "a validator that returns no messages"
    end

    context "when checksums filenames are not in sip files." do
      let(:file_list) { %w(foo bar baz) + exempt_filenames }
      before(:each) { allow(mock_checksums).to receive(:checksum_for).and_return(nil) }

      it_behaves_like "a validator with an invalid package"

      it "generates an error message for each missing filename not in exempt list." do
        returned_messages = validator.validate
        expect(returned_messages.count).to eq(file_list.count - exempt_filenames.count)
        expect(returned_messages.all?(&:error?)).to be true
      end
    end
  end
end
