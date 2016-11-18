# frozen_string_literal: true
require "spec_helper"

module HathiTrust
  describe Validator::OCR::CoordinateFormat do
    let(:mocked_sip) { SIP::SIP.new("") }
    let(:validator) { described_class.new(mocked_sip) }

    describe "#validate" do
      context "when package contains only xml coordinate OCR" do
        let(:file_list) do
          %w(00000001.tif 00000001.txt 00000001.xml 00000002.tif 00000002.txt
             00000002.xml checksum.md5 meta.yml)
        end
        before(:each) { allow(mocked_sip).to receive(:files).and_return(file_list) }

        it_behaves_like "a validator with a valid package"
        it_behaves_like "a validator that returns no messages"
      end

      context "when package contains only html coordinate OCR" do
        let(:file_list) do
          %w(00000001.tif 00000001.txt 00000001.html 00000002.tif 00000002.txt
             00000002.html checksum.md5 meta.yml)
        end
        before(:each) { allow(mocked_sip).to receive(:files).and_return(file_list) }

        it_behaves_like "a validator with a valid package"
        it_behaves_like "a validator that returns no messages"
      end

      context "when package contains a mix of xml and html coordinate OCR " do
        let(:file_list) do
          %w(00000001.tif 00000001.txt 00000001.xml 00000002.tif 00000002.txt
             00000002.html checksum.md5 meta.yml)
        end
        before(:each) { allow(mocked_sip).to receive(:files).and_return(file_list) }

        it_behaves_like "a validator with warnings and only warnings"

        it "returns an appropriate message" do
          expect(human_messages(validator.validate))
            .to include(a_string_matching(/xml.*html/))
        end
      end
    end
  end
end
