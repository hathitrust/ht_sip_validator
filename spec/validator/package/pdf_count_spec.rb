# frozen_string_literal: true

require "spec_helper"

describe HathiTrust::Validator::Package::PDFCount do
  let(:mocked_sip) { HathiTrust::SIP::SIP.new("") }
  let(:validator) { described_class.new(mocked_sip) }

  describe "#validate" do
    context "when package contains no pdfs" do
      let(:file_list) do
        %w[00000001.tif checksum.md5 meta.yml]
      end
      before(:each) { allow(mocked_sip).to receive(:files).and_return(file_list) }

      it_behaves_like "a validator with a valid package"
      it_behaves_like "a validator that returns no messages"
    end

    context "when package contains one pdf" do
      let(:file_list) do
        %w[00000001.tif whatever.pdf checksum.md5 meta.yml]
      end
      before(:each) { allow(mocked_sip).to receive(:files).and_return(file_list) }

      it_behaves_like "a validator with a valid package"
      it_behaves_like "a validator that returns no messages"
    end

    context "when package contains two pdfs" do
      let(:file_list) do
        %w[00000001.tif whatever.pdf someother.pdf checksum.md5 meta.yml]
      end
      before(:each) { allow(mocked_sip).to receive(:files).and_return(file_list) }

      it_behaves_like "a validator with an invalid package"

      it "returns an appropriate message" do
        expect(human_messages(validator.validate))
          .to include(a_string_matching(/pdf/))
      end
    end
  end
end
