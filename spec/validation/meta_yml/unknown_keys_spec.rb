# frozen_string_literal: true
require "spec_helper"

module HathiTrust
  module Validation
    module MetaYml


      describe UnknownKeys do
        describe "#validate" do
          include_context "with yaml fixtures"

          let(:mocked_sip) { SIP::SIP.new("") }
          subject(:validator) { described_class.new(mocked_sip) }

          context "when meta.yml has only known keys" do
            before(:each) { allow(mocked_sip).to receive(:meta_yml) .and_return(valid_yaml) }

            it_behaves_like "a validator with a valid package"

            it "does not return any messages" do
              expect(validator.validate.length).to be(0)
            end
          end

          context "when meta.yml has an unknown key" do
            before(:each) { allow(mocked_sip).to receive(:meta_yml) .and_return(invalid_yaml) }

            it_behaves_like "a validator with warnings and only warnings"

            it "returns an appropriate message" do
              expect(human_messages(validator.validate))
                .to include(a_string_matching(/capture_elephant/))
            end

          end
        end
      end


    end
  end
end
