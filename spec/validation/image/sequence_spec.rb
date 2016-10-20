# frozen_string_literal: true
require "spec_helper"

describe HathiTrust::Validation::Image::Sequence do
  let(:mocked_sip) { HathiTrust::SIP::SIP.new("") }
  let(:validation) { described_class.new(mocked_sip) }

  describe "#validate" do
    context "when image files sequence is complete." do
      let(:file_list) do
        %w(00000001.tif 00000001.txt 00000002.jp2 00000002.txt
           00000003.txt 00000003.jp2 checksum.md5 meta.yml)
      end

      before(:each) { allow(mocked_sip).to receive(:files).and_return(file_list) }

      it_behaves_like "a validation with a valid package"
      it_behaves_like "a validation that returns no messages"
    end

    context "when image files do not exist." do
      let(:file_list) { %w(00000001.txt 00000002.txt 00000003.txt checksum.md5 meta.yml) }

      before(:each) { allow(mocked_sip).to receive(:files).and_return(file_list) }

      it_behaves_like "a validation with an invalid package"
    end

    context "when there is a gap in the image file sequence." do
      let(:file_list) do
        %w(00000001.tif 00000001.txt 00000002.jp2 00000002.txt
           00000004.txt 00000004.jp2 00000006.txt 00000006.jp2
           checksum.md5 meta.yml)
      end
      before(:each) { allow(mocked_sip).to receive(:files).and_return(file_list) }

      it_behaves_like "a validation with an invalid package"

      it "emits an error for each gap in the file sequence." do
        returned_messages = validation.validate
        expect(returned_messages.count).to eq(2)
        expect(returned_messages.all?(&:error?)).to be true
      end
    end

    context "when there is a duplicate in the image file sequence." do
      let(:file_list) do
        %w(00000001.tif 00000001.txt 00000002.jp2 00000002.txt
           00000001.tif 00000001.txt 00000002.jp2 00000002.txt
           00000003.tif 00000003.txt 00000004.jp2 00000004.txt
           checksum.md5 meta.yml)
      end
      before(:each) { allow(mocked_sip).to receive(:files).and_return(file_list) }

      it_behaves_like "a validation with an invalid package"

      it "emits an error for each duplication in the file sequence." do
        returned_messages = validation.validate
        expect(returned_messages.count).to eq(2)
        expect(returned_messages.all?(&:error?)).to be true
      end
    end
  end
end
