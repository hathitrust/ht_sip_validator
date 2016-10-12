# frozen_string_literal: true
require "spec_helper"

module HathiTrust
  module Validation
    module MetaYml

      describe RequiredKeys do
        def valid_yaml
          YAML.load("capture_date: 2013-11-01T12:31:00-05:00")
        end

        def invalid_yaml
          YAML.load("capture_elephant: do it.")
        end

        describe "#validate" do
          let(:mocked_sip) { SIP::SIP.new("") }
          subject(:validator) { described_class.new(mocked_sip) }

          context "when meta.yml has capture_date" do
            before(:each) { allow(mocked_sip).to receive(:meta_yml) .and_return(valid_yaml) }

            it_behaves_like "a validator with a valid package"
          end

          context "when meta.yml does not have capture_date" do
            before(:each) { allow(mocked_sip).to receive(:meta_yml) .and_return(invalid_yaml) }

            it_behaves_like "a validator with an invalid package"

            it "returns an appropriate error" do
              expect(human_messages(validator.validate))
                .to include(a_string_matching(/capture_date/))
            end
          end
        end
      end

    end
  end
end
