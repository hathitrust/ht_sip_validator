# frozen_string_literal: true
require "spec_helper"

describe HathiTrust::Validator::Package::FileTypes do
  let(:mocked_sip) { HathiTrust::SIP::SIP.new("") }
  let(:validator) { described_class.new(mocked_sip) }

  describe "#validate" do
    context "when filename extensions meet requirements" do
      let(:file_list) do
        %w(00000001.tif 00000001.txt 00000002.jp2 00000002.txt
           00000001.html 00000002.xml marc.xml checksum.md5 meta.yml foo.pdf)
      end
      before(:each) { allow(mocked_sip).to receive(:files).and_return(file_list) }

      it_behaves_like "a validator with a valid package"
      it_behaves_like "a validator that returns no messages"
    end

    context "with invalid filename extensions" do
      let(:file_list) { %w(00000001.png 00000002.jpg checksum.md5 meta.yml) }
      before(:each) { allow(mocked_sip).to receive(:files).and_return(file_list) }

      it_behaves_like "a validator with warnings and only warnings"

      it "returns an appropriate message" do
        expect(human_messages(validator.validate))
          .to include(a_string_matching(/\.png/))
      end
    end
  end
end
