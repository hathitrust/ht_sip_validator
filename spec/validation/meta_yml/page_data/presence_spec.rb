# frozen_string_literal: true
require "spec_helper"

module HathiTrust
  module Validation
    module MetaYml
      module PageData
        describe Presence do
          describe "#validate" do
            include_context "with pagedata fixtures"
            subject(:validation) { described_class.new(mocked_sip) }

            context "when page data is missing" do
              before(:each) { allow(mocked_sip).to receive(:meta_yml).and_return(no_pagedata) }
              it_behaves_like "a validation with warnings and only warnings"

              it "returns an appropriate message" do
                expect(human_messages(validation.validate))
                  .to include(a_string_matching(/page/))
              end
            end
          end
        end
      end
    end
  end
end
