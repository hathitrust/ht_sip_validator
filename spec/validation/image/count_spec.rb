# frozen_string_literal: true
require "spec_helper"

describe HathiTrust::Validator::Image::Count do
  let(:mocked_sip) { HathiTrust::SIP::SIP.new("") }
  let(:validation) { described_class.new(mocked_sip) }

  describe "#validate" do
    context "when image count matches text file count." do
      let(:file_list) do
        %w(00000001.tif 00000001.txt 00000002.jp2 00000002.txt
           00000003.txt 00000003.jp2 checksum.md5 meta.yml)
      end
      before(:each) { allow(mocked_sip).to receive(:files).and_return(file_list) }

      it_behaves_like "a validation with a valid package"
      it_behaves_like "a validation that returns no messages"
    end

    context "when image count differs from text file count." do
      let(:file_list) do
        %w(00000001.tif 00000001.txt 00000002.jp2 00000002.txt
           00000003.txt 00000003.jp2 00000004.jp2 checksum.md5 meta.yml)
      end
      before(:each) { allow(mocked_sip).to receive(:files).and_return(file_list) }

      it_behaves_like "a validation with an invalid package"
    end

  end
end
