# frozen_string_literal: true

require "spec_helper"

module HathiTrust
  describe Validator::MetaYml::PageData::Keys do
    describe "#validate" do
      include_context "with pagedata fixtures"
      subject(:validator) { described_class.new(mocked_sip) }

      context "when page data is a hash with filename keys whose values are hashes with label and/or orderlabel" do
        before(:each) { allow(mocked_sip).to receive(:metadata).and_return(good_pagedata) }
        it_behaves_like "a validator with a valid package"
        it_behaves_like "a validator with the correct interface"

        it "does not return any messages" do
          expect(validator.validate.length).to be(0)
        end
      end

      context "when page data has a sequence number only" do
        before(:each) do
          allow(mocked_sip).to receive(:metadata)
            .and_return(pagedata_with(1 => {"label" => "FRONT_COVER"}))
        end

        it_behaves_like "a validator with an invalid package"

        it "returns an appropriate error message" do
          expect(human_messages(validator.validate))
            .to include(a_string_matching(/filename/))
        end
      end

      context "when page data has keys from the wrong scope" do
        before(:each) do
          allow(mocked_sip).to receive(:metadata)
            .and_return(pagedata_with("tiff_artist" => "University of Michigan"))
        end

        it_behaves_like "a validator with an invalid package"

        it "returns an appropriate error message" do
          expect(human_messages(validator.validate))
            .to include(a_string_matching(/filename/))
        end
      end

      it_behaves_like "a validator that can handle missing pagedata"
    end
  end
end
