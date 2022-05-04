# frozen_string_literal: true

require "spec_helper"

describe HathiTrust::Validator::Package::FileBasenames do
  let(:mocked_sip) { HathiTrust::SIP::SIP.new("") }
  let(:validator) { described_class.new(mocked_sip) }

  describe "#validate" do
    context "when image filenames are all 8 digits." do
      let(:file_list) do
        %w[00000001.tif 00000001.txt 00000002.jp2 00000002.txt
          00000003.txt 00000003.jp2 checksum.md5 meta.yml]
      end
      before(:each) { allow(mocked_sip).to receive(:files).and_return(file_list) }

      it_behaves_like "a validator with a valid package"
      it_behaves_like "a validator that returns no messages"
    end

    context "when image filenames are not all 8 digits." do
      let(:file_list) do
        %w[000000001.tif 00000001.txt 000000a2.jp2 00000002.txt
          00000003.txt 000000_3.jp2 checksum.md5 meta.yml]
      end
      before(:each) { allow(mocked_sip).to receive(:files).and_return(file_list) }

      it_behaves_like "a validator with an invalid package"

      it "returns an appropriate message for a 9-digit image filename" do
        expect(human_messages(validator.validate))
          .to include(a_string_matching(/00000001\.tif/))
      end

      it "returns an appropriate message for a non-numeric image filename" do
        expect(human_messages(validator.validate))
          .to include(a_string_matching(/000000a2\.jp2/))
      end

      it "returns an appropriate message for a image filename with underscores" do
        expect(human_messages(validator.validate))
          .to include(a_string_matching(/000000_3\.jp2/))
      end
    end

    context "when ocr filenames are all numeric." do
      let(:file_list) do
        %w[00000001.tif 00000001.txt 00000002.jp2 00000002.txt
          00000003.txt 00000003.jp2 checksum.md5 meta.yml]
      end
      before(:each) { allow(mocked_sip).to receive(:files).and_return(file_list) }

      it_behaves_like "a validator with a valid package"
      it_behaves_like "a validator that returns no messages"
    end

    context "when ocr filenames are not all numeric." do
      let(:file_list) do
        %w[00000001.tif 000asdf00001.txt 00000002.jp2 000000a2.txt
          00000003_2.txt 00000003.jp2 checksum.md5 meta.yml]
      end
      before(:each) { allow(mocked_sip).to receive(:files).and_return(file_list) }

      it_behaves_like "a validator with an invalid package"

      it "returns an appropriate message for a non-numeric OCR filename" do
        expect(human_messages(validator.validate))
          .to include(a_string_matching(/000asdf00001\.txt/))
      end
    end
  end
end
