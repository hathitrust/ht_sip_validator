# frozen_string_literal: true
require "spec_helper"

module HathiTrust
  describe Validator::MetaYml::PageData::Presence do
    describe "#validate" do
      include_context "with pagedata fixtures"
      subject(:validator) { described_class.new(mocked_sip) }

      context "when page data is missing" do
        before(:each) { allow(mocked_sip).to receive(:meta_yml).and_return(no_pagedata) }
        it_behaves_like "a validator with warnings and only warnings"
        it_behaves_like "a validator with the correct interface"

        it "returns an appropriate message" do
          expect(human_messages(validator.validate))
            .to include(a_string_matching(/page/))
        end
      end
    end
  end
end
