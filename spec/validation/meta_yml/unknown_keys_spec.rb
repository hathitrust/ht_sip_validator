# frozen_string_literal: true
require "spec_helper"

module HathiTrust

  describe Validation::MetaYml::UnknownKeys do
    describe "#validate" do
      include_context "with yaml fixtures"

      let(:mocked_sip) { SIP::SIP.new("") }
      subject(:validation) { described_class.new(mocked_sip) }

      context "when meta.yml has only known keys" do
        before(:each) { allow(mocked_sip).to receive(:meta_yml) .and_return(valid_yaml) }

        it_behaves_like "a validation with the correct interface"
        it_behaves_like "a validation with a valid package"
        it_behaves_like "a validation that returns no messages"
      end

      context "when meta.yml has an unknown key" do
        before(:each) { allow(mocked_sip).to receive(:meta_yml) .and_return(invalid_yaml) }

        it_behaves_like "a validation with warnings and only warnings"

        it "returns an appropriate message" do
          expect(human_messages(validation.validate))
            .to include(a_string_matching(/capture_elephant/))
        end
      end
    end
  end

end
