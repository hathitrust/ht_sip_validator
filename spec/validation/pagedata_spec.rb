# frozen_string_literal: true
require "spec_helper"

include HathiTrust
include Validation::MetaYml::PageData

describe Validation::MetaYml::PageData do
  let(:mocked_sip) { SIP::SIP.new("") }

  describe Structure do
    describe "#validate" do
      subject(:validator) { described_class.new(mocked_sip) }

      context "when page data is missing" do
        before(:each) { allow(mocked_sip).to receive(:meta_yml).and_return(no_pagedata) }
        it_behaves_like "a validator with warnings and only warnings"

        it "returns an appropriate message" do
          expect(human_messages(validator.validate))
            .to include(a_string_matching(/page/))
        end
      end

      context "when page data is a hash with filenames whose keys have label and/or orderlabel" do
        before(:each) { allow(mocked_sip).to receive(:meta_yml).and_return(good_pagedata) }
        it_behaves_like "a validator with a valid package"

        it "does not return any messages" do
          expect(validator.validate.length).to be(0)
        end
      end

      context "when page data has a sequence number only" do
        before(:each) do
          allow(mocked_sip).to receive(:meta_yml)
            .and_return(pagedata_with('00000001: { label: "FRONT_COVER" }'))
        end

        it_behaves_like "a validator with an invalid package"

        it "returns an appropriate error message" do
          expect(human_messages(validator.validate))
            .to include(a_string_matching(/filename/))
        end
      end

      context "when page data has keys from the wrong scope" do
        before(:each) do
          allow(mocked_sip).to receive(:meta_yml)
            .and_return(pagedata_with('tiff_artist: "University of Michigan"'))
        end

        it_behaves_like "a validator with an invalid package"

        it "returns an appropriate error message" do
          expect(human_messages(validator.validate))
            .to include(a_string_matching(/filename/))
        end
      end

      context "when page data for a page does not have a hash value" do
        before(:each) do
          allow(mocked_sip).to receive(:meta_yml)
            .and_return(pagedata_with('00000001.tif: "FRONT_COVER"'))
        end

        it_behaves_like "a validator with an invalid package"

        it "returns an appropriate error message" do
          expect(human_messages(validator.validate))
            .to include(a_string_matching(/{.*label/))
        end
      end

      context "when page data has bad keys for its hash" do
        before(:each) do
          allow(mocked_sip).to receive(:meta_yml)
            .and_return(pagedata_with("00000001.tif: { who: 'what', when: 'where' }"))
        end

        it_behaves_like "a validator with an invalid package"

        it "returns an appropriate error message" do
          expect(human_messages(validator.validate))
            .to include(a_string_matching(/{.*label/))
        end
      end
    end
  end

  # Ensure that every file referenced in the page data refers to a file actually
  # present in the SIP
  describe Files do
    describe "#validate" do
      subject(:validator) { described_class.new(mocked_sip) }

      context "when all files are present for the provided pagedata" do
        before(:each) do
          allow(mocked_sip).to receive(:meta_yml)
            .and_return(pagedata_with('00000001.tif: { label: "FRONT_COVER" }'))

          allow(mocked_sip).to receive(:files)
            .and_return(%w(meta.yml checksum.md5 00000001.tif))
        end

        it_behaves_like "a validator with a valid package"
      end

      context "when a file is missing that is referenced in the pagedata" do
        before(:each) do
          allow(mocked_sip).to receive(:meta_yml)
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
