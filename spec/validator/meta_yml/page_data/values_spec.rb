# frozen_string_literal: true

require "spec_helper"

module HathiTrust
  describe Validator::MetaYml::PageData::Values do
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

      context "when page data values have unexpected keys" do
        before(:each) do
          allow(mocked_sip).to receive(:metadata)
            .and_return(pagedata_with("00000001.tif" => {"aardvark" => "FRONT_COVER"}))
        end

        it_behaves_like "a validator with an invalid package"

        it "returns an appropriate error message" do
          expect(human_messages(validator.validate))
            .to include(a_string_matching(/aardvark/))
        end
      end

      context "when page data value is not a hash" do
        before(:each) do
          allow(mocked_sip).to receive(:metadata)
            .and_return(pagedata_with("00000001.tif" => "aardvark"))
        end

        it_behaves_like "a validator with an invalid package"

        it "returns an appropriate error message" do
          expect(human_messages(validator.validate))
            .to include(a_string_matching(/aardvark/))
        end
      end

      it_behaves_like "a validator that can handle missing pagedata"
    end
  end
end
