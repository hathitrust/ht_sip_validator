# frozen_string_literal: true

require "spec_helper"

describe HathiTrust::Validator::OCR::CoordinatePresence do
  let(:mocked_sip) { HathiTrust::SIP::SIP.new("") }
  let(:validator) { described_class.new(mocked_sip) }

  describe "#validate" do
    context "when all images have ocr & coordinate OCR" do
      let(:file_list) do
        %w[00000001.tif 00000001.txt 00000001.xml 00000002.jp2 00000002.txt
          00000002.xml 00000003.txt 00000003.jp2 00000003.xml
          checksum.md5 meta.yml]
      end
      before(:each) { allow(mocked_sip).to receive(:files).and_return(file_list) }

      it_behaves_like "a validator with a valid package"
      it_behaves_like "a validator that returns no messages"
    end

    context "when some coordinate OCR is missing" do
      let(:file_list) do
        %w[00000001.tif 00000001.txt 00000001.xml 00000002.jp2 00000002.txt 00000002.xml
          00000003.txt 00000003.jp2 checksum.md5 meta.yml]
      end
      before(:each) { allow(mocked_sip).to receive(:files).and_return(file_list) }

      it_behaves_like "a validator with warnings and only warnings"

      it "returns an appropriate message" do
        expect(human_messages(validator.validate))
          .to include(a_string_matching(/00000003/))
      end
    end
  end
end
