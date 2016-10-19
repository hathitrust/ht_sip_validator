# frozen_string_literal: true
require "spec_helper"

module HathiTrust

  describe Validation::MetaYml::RequiredKeys do

    describe "#validate" do
      include_context "with yaml fixtures"
      let(:mocked_sip) { SIP::SIP.new("") }
      subject(:validation) { described_class.new(mocked_sip) }

      context "when meta.yml has capture_date" do
        before(:each) { allow(mocked_sip).to receive(:meta_yml) .and_return(valid_yaml) }

        it_behaves_like "a validation with a valid package"
      end

      context "when meta.yml does not have capture_date" do
        before(:each) { allow(mocked_sip).to receive(:meta_yml) .and_return(invalid_yaml) }

        it_behaves_like "a validation with an invalid package"

        it "returns an appropriate message" do
          expect(human_messages(validation.validate))
            .to include(a_string_matching(/capture_date/))
        end
      end
    end
  end

end
