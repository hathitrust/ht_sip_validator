# frozen_string_literal: true

require "spec_helper"

module HathiTrust
  describe Validator::Package::MarcXML do
    let(:mocked_sip) { SIP::SIP.new("") }
    let(:validator) { described_class.new(mocked_sip) }

    describe "#validate" do
      context "when package does not contain marc.xml" do
        let(:file_list) do
          %w[00000001.tif 00000001.txt checksum.md5 meta.yml]
        end
        before(:each) { allow(mocked_sip).to receive(:files).and_return(file_list) }

        it_behaves_like "a validator with a valid package"
        it_behaves_like "a validator that returns no messages"
      end

      context "when package contains marc.xml" do
        let(:file_list) { %w[00000001.tif 00000001.txt checksum.md5 meta.yml marc.xml] }
        before(:each) { allow(mocked_sip).to receive(:files).and_return(file_list) }

        it_behaves_like "a validator with warnings and only warnings"

        it "returns an appropriate message" do
          expect(human_messages(validator.validate))
            .to include(a_string_matching(/marc.xml/))
        end
      end
    end
  end
end
