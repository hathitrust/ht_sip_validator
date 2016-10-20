# frozen_string_literal: true
require "spec_helper"

describe HathiTrust::Validation::Checksums::Exists do
  let(:mocked_sip) { HathiTrust::SIP::SIP.new("") }
  let(:validation) { described_class.new(mocked_sip) }

  describe "#validate" do
    context "when checksum file exists in the package" do
      before(:each) { allow(mocked_sip).to receive(:files).and_return([HathiTrust::SIP::CHECKSUM_FILE]) }

      it_behaves_like "a validation with a valid package"
      it_behaves_like "a validation that returns no messages"
    end

    context "when checksum file does not exist in the package" do
      before(:each) { allow(mocked_sip).to receive(:files).and_return([]) }

      it_behaves_like "a validation with an invalid package"

      it "returns an appropriate error" do
        expect(human_messages(validation.validate))
          .to include(a_string_matching(/missing #{HathiTrust::SIP::CHECKSUM_FILE}/))
      end
    end
  end
end

describe HathiTrust::Validation::Checksums::FileListComplete do
  let(:mocked_sip) { HathiTrust::SIP::SIP.new("") }
  let(:exempt_filenames) { HathiTrust::Validation::Checksums::EXEMPT_FILENAMES }
  let(:mock_checksums) { instance_double("HathiTrust::SIP::Checksums") }
  let(:validation) { described_class.new(mocked_sip) }

  before(:each) { allow(mocked_sip).to receive(:files).and_return(file_list) }
  before(:each) { allow(mocked_sip).to receive(:checksums).and_return(mock_checksums) }

  describe "#validate" do
    context "when checksums filenames match sip files." do
      let(:file_list) { %w(foo bar baz) }
      before(:each) { allow(mock_checksums).to receive(:checksum_for) {|arg| arg } }

      it_behaves_like "a validation with a valid package"
      it_behaves_like "a validation that returns no messages"
    end

    context "when sip files include checksum exempt filenames." do
      let(:file_list) { %w(foo bar baz) + exempt_filenames }
      before(:each) { allow(mock_checksums).to receive(:checksum_for) {|arg| arg } }

      it_behaves_like "a validation with a valid package"
      it_behaves_like "a validation that returns no messages"
    end

    context "when checksums filenames are not in sip files." do
      let(:file_list) { %w(foo bar baz) + exempt_filenames }
      before(:each) { allow(mock_checksums).to receive(:checksum_for).and_return(nil) }

      it_behaves_like "a validation with an invalid package"

      it "generates an error message for each missing filename not in exempt list." do
        returned_messages = validation.validate
        expect(returned_messages.count).to eq(file_list.count - exempt_filenames.count)
        expect(returned_messages.all?(&:error?)).to be true
      end
    end
  end
end

describe HathiTrust::Validation::Checksums::WellFormed do
  let(:mocked_sip) { HathiTrust::SIP::SIP.new("") }
  let(:exempt_filenames) { HathiTrust::Validation::Checksums::EXEMPT_FILENAMES }
  let(:mock_checksums) { instance_double("HathiTrust::SIP::Checksums") }
  let(:validation) { described_class.new(mocked_sip) }

  before(:each) { allow(mocked_sip).to receive(:checksums).and_return(mock_checksums) }
  before(:each) { allow(mock_checksums).to receive(:checksums).and_return(checksums_hash) }

  context "with well formed checksums" do
    let(:checksums_hash) do
      { 'filename1': "b0ee419150085f64ef8311dc3919d1a3",
        'filename2': "d2e0dceff9e2e8bce3ec82a9760f4f61",
        'filename3': "24f9133e5b40ef61a1879df2a6de8a48" }
    end

    it_behaves_like "a validation with a valid package"
    it_behaves_like "a validation that returns no messages"
  end

  context "with malformed checksums" do
    let(:checksums_hash) do
      { 'filename1': "deadbeefdeadbeefdeadbeefdeadbeefdeadbeef",
        'filename2': "deadbeefdeadbeefdeadbeef",
        'filename3': "qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq",
        'filename4': "-*//$&^fffffffffffffffffffffffff" }
    end

    it_behaves_like "a validation with an invalid package"

    it "generates an error message for each checksum value." do
      returned_messages = validation.validate
      expect(returned_messages.count).to eq(checksums_hash.count)
      expect(returned_messages.all?(&:error?)).to be true
    end

    it "generates error messages that indicate the bad value." do
      checksums_hash.each do |_filename, bad_value|
        expect(human_messages(validation.validate)).to include(a_string_including(bad_value))
      end
    end
  end
end
