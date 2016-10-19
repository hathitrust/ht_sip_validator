# frozen_string_literal: true
require "spec_helper"

# Ensure that every file referenced in the page data refers to a file actually
# present in the SIP
module HathiTrust
  describe Validation::MetaYml::PageData::Files do
    include_context "with pagedata fixtures"

    describe "#validate" do
      subject(:validation) { described_class.new(mocked_sip) }

      context "when all files are present for the provided pagedata" do
        before(:each) do
          allow(mocked_sip).to receive(:meta_yml)
            .and_return(pagedata_with('00000001.tif: { label: "FRONT_COVER" }'))

          allow(mocked_sip).to receive(:files)
            .and_return(%w(meta.yml checksum.md5 00000001.tif))
        end

        it_behaves_like "a validation with a valid package"
      end

      context "when a file is missing that is referenced in the pagedata" do
        before(:each) do
          allow(mocked_sip).to receive(:meta_yml)
            .and_return(pagedata_with('00000001.jp2: { label: "FRONT_COVER" }'))

          allow(mocked_sip).to receive(:files)
            .and_return(%w(meta.yml checksum.md5 00000001.tif))
        end

        it_behaves_like "a validation with an invalid package"

        it "returns an appropriate error message" do
          expect(human_messages(validation.validate))
            .to include(a_string_matching(/.*pagedata.*00000001/))
        end
      end
    end
  end
end
