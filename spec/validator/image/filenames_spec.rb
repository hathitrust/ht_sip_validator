# frozen_string_literal: true
require "spec_helper"

describe HathiTrust::Validator::Image::Filenames do
  let(:mocked_sip) { HathiTrust::SIP::SIP.new("") }
  let(:validator) { described_class.new(mocked_sip) }

  describe "#validate" do
    context "when image filenames are all numeric." do
      let(:file_list) do
        %w(00000001.tif 00000001.txt 00000002.jp2 00000002.txt
           00000003.txt 00000003.jp2 checksum.md5 meta.yml)
      end
      before(:each) { allow(mocked_sip).to receive(:files).and_return(file_list) }

      it_behaves_like "a validator with a valid package"
      it_behaves_like "a validator that returns no messages"
    end

    context "when there are no image filenames" do
      let(:file_list) { %w(00000001.txt 00000002.txt 00000003.txt checksum.md5 meta.yml) }
      before(:each) { allow(mocked_sip).to receive(:files).and_return(file_list) }

      it_behaves_like "a validator with an invalid package"
    end

    context "when image filenames are not all numeric." do
      let(:file_list) do
        %w(00000001.tif 00000001.txt 000000a2.jp2 00000002.txt
           00000003.txt 000000_3.jp2 checksum.md5 meta.yml)
      end
      before(:each) { allow(mocked_sip).to receive(:files).and_return(file_list) }

      it_behaves_like "a validator with an invalid package"
    end
  end
end
