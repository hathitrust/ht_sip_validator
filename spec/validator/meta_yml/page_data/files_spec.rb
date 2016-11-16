# frozen_string_literal: true
require "spec_helper"

# Ensure that every file referenced in the page data refers to a file actually
# present in the SIP
module HathiTrust
  describe Validator::MetaYml::PageData::Files do
    include_context "with pagedata fixtures"
    subject(:validator) { described_class.new(mocked_sip) }

    describe "#validate" do
      context "when all files are present for the provided pagedata" do
        before(:each) do
          allow(mocked_sip).to receive(:metadata)
            .and_return(pagedata_with('00000001.tif: { label: "FRONT_COVER" }'))

          allow(mocked_sip).to receive(:files)
            .and_return(%w(meta.yml checksum.md5 00000001.tif))
        end

        it_behaves_like "a validator with the correct interface"
        it_behaves_like "a validator with a valid package"
      end

      context "when a file is missing that is referenced in the pagedata" do
        before(:each) do
          allow(mocked_sip).to receive(:metadata)
            .and_return(pagedata_with('00000001.jp2: { label: "FRONT_COVER" }'))

          allow(mocked_sip).to receive(:files)
            .and_return(%w(meta.yml checksum.md5 00000001.tif))
        end

        it_behaves_like "a validator with an invalid package"

        it "returns an appropriate error message" do
          expect(human_messages(validator.validate))
            .to include(a_string_matching(/.*pagedata.*00000001/))
        end
      end
    end
  end
end
