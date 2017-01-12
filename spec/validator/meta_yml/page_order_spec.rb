# frozen_string_literal: true
require "spec_helper"

module HathiTrust
  describe Validator::MetaYml::PageOrder do
    describe "#validate" do
      include_context "with yaml fixtures"
      let(:mocked_sip) { SIP::SIP.new("") }
      subject(:validator) { described_class.new(mocked_sip) }

      context "when meta.yml has scanning and reading order" do
        before(:each) do
          allow(mocked_sip).to receive(:metadata)
            .and_return(SIP::YAML.load("scanning_order: left-to-right\nreading_order: right-to-left")
                      .merge(valid_yaml))
        end

        it_behaves_like "a validator with the correct interface"
        it_behaves_like "a validator with a valid package"
        it_behaves_like "a validator that returns no messages"
      end

      context "when meta.yml has neither reading nor scanning order" do
        before(:each) do
          allow(mocked_sip).to receive(:metadata)
            .and_return(valid_yaml)
        end

        it_behaves_like "a validator with warnings and only warnings"

        it "returns an appropriate message" do
          expect(human_messages(validator.validate))
            .to include(a_string_matching(/default.*left-to-right/))
        end
      end

      context "when meta.yml has only reading order" do
        before(:each) do
          allow(mocked_sip).to receive(:metadata)
            .and_return(SIP::YAML.load("reading_order: right-to-left")
                      .merge(valid_yaml))
        end

        it_behaves_like "a validator with an invalid package"

        it "returns an appropriate message" do
          expect(human_messages(validator.validate))
            .to include(a_string_matching(/missing.*scanning_order/))
        end
      end

      context "when meta.yml has only scanning order" do
        before(:each) do
          allow(mocked_sip).to receive(:metadata)
            .and_return(SIP::YAML.load("scanning_order: right-to-left")
                      .merge(valid_yaml))
        end

        it_behaves_like "a validator with an invalid package"

        it "returns an appropriate message" do
          expect(human_messages(validator.validate))
            .to include(a_string_matching(/missing.*reading_order/))
        end
      end

      context "when meta.yml has invalid scanning or reading order" do
        before(:each) do
          allow(mocked_sip).to receive(:metadata)
            .and_return(SIP::YAML.load("scanning_order: top-to-bottom\n"\
                                "reading_order: follows-scanning-order")
          .merge(valid_yaml))
        end

        it_behaves_like "a validator with an invalid package"

        it "returns an appropriate message" do
          expect(human_messages(validator.validate))
            .to include(a_string_matching(/scanning_order.*top-to-bottom/))
          expect(human_messages(validator.validate))
            .to include(a_string_matching(/reading_order.*follows-scanning-order/))
        end
      end
    end
  end
end
