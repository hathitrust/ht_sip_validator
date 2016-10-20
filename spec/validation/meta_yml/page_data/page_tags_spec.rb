# frozen_string_literal: true
require "spec_helper"

# Ensure that every file referenced in the page data refers to a file actually
# present in the SIP
module HathiTrust
  module Validation
    module MetaYml
      module PageData
        describe PageTags do
          include_context "with pagedata fixtures"
          subject(:validation) { described_class.new(mocked_sip) }

          describe "#validate" do
            context "when pagetags are all known" do
              before(:each) do
                allow(mocked_sip).to receive(:meta_yml)
                  .and_return(pagedata_with('00000001.tif: { orderlabel: "1", '\
                                          'label: "IMAGE_ON_PAGE, FRONT_COVER" }'))

                allow(mocked_sip).to receive(:files)
                  .and_return(%w(meta.yml checksum.md5 00000001.tif))
              end

              it_behaves_like "a validation with the correct interface"
              it_behaves_like "a validation with a valid package"
            end

            context "with one unknown tag" do
              before(:each) do
                allow(mocked_sip).to receive(:meta_yml)
                  .and_return(pagedata_with('00000001.tif: { label: "GARBAGE" }'))
              end

              it_behaves_like "a validation with an invalid package"

              it "returns an appropriate warning message" do
                expect(human_messages(validation.validate))
                  .to include(a_string_matching(/GARBAGE.*00000001\.tif/))
              end
            end

            context "with one known and one unknown tag" do
              before(:each) do
                allow(mocked_sip).to receive(:meta_yml)
                  .and_return(pagedata_with('00000001.tif: { label: "FRONT_COVER, GARBAGE" }'))
              end

              it_behaves_like "a validation with an invalid package"

              it "returns only one error" do
                expect(human_messages(validation.validate).count).to be(1)
              end
            end
          end
        end

      end
    end
  end
end
