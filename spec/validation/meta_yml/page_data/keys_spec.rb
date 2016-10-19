# frozen_string_literal: true
require "spec_helper"

module HathiTrust
  module Validation
    module MetaYml
      module PageData
        describe Keys do
          describe "#validate" do
            include_context "with pagedata fixtures"
            subject(:validation) { described_class.new(mocked_sip) }

            context "when page data is a hash with filenames whose keys have label and/or orderlabel" do
              before(:each) { allow(mocked_sip).to receive(:meta_yml).and_return(good_pagedata) }
              it_behaves_like "a validation with a valid package"

              it "does not return any messages" do
                expect(validation.validate.length).to be(0)
              end
            end

            context "when page data has a sequence number only" do
              before(:each) do
                allow(mocked_sip).to receive(:meta_yml)
                  .and_return(pagedata_with('00000001: { label: "FRONT_COVER" }'))
              end

              it_behaves_like "a validation with an invalid package"

              it "returns an appropriate error message" do
                expect(human_messages(validation.validate))
                  .to include(a_string_matching(/filename/))
              end
            end

            context "when page data has keys from the wrong scope" do
              before(:each) do
                allow(mocked_sip).to receive(:meta_yml)
                  .and_return(pagedata_with('tiff_artist: "University of Michigan"'))
              end

              it_behaves_like "a validation with an invalid package"

              it "returns an appropriate error message" do
                expect(human_messages(validation.validate))
                  .to include(a_string_matching(/filename/))
              end
            end
          end
        end
      end
    end
  end
end
