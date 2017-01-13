# frozen_string_literal: true
require "spec_helper"

describe HathiTrust::Validator::OCR::CoordinateHasPlain do
  let(:mocked_sip) { HathiTrust::SIP::SIP.new("") }
  let(:validator) { described_class.new(mocked_sip) }

  describe "#validate" do
    context "when all ocr files and coordinate ocr files have corresponding images" do
      let(:file_list) do
        %w(00000001.tif 00000001.txt 00000001.xml 00000002.jp2 00000002.txt
           00000002.xml 00000003.txt 00000003.jp2 00000003.xml checksum.md5
           meta.yml)
      end

      before(:each) { allow(mocked_sip).to receive(:files).and_return(file_list) }

      it_behaves_like "a validator with a valid package"
      it_behaves_like "a validator that returns no messages"
    end

    context "when there is xml file without corresponding txt" do
      let(:file_list) { %w(00000001.xml 00000001.jp2 checksum.md5 meta.yml) }

      before(:each) { allow(mocked_sip).to receive(:files).and_return(file_list) }

      it_behaves_like "a validator with an invalid package"

      it "produces an message that references the offending file" do
        messages = human_messages(validator.validate)
        expect(messages).to include(a_string_matching(/00000001.xml/))
      end
    end
  end
end
