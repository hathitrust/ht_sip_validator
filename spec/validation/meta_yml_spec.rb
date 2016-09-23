# frozen_string_literal: true
require "spec_helper"

module HathiTrust
  module Validation
    module MetaYml

      describe Exists do
        let(:mocked_sip) { SIP::SIP.new("") }
        subject(:validator) { described_class.new(mocked_sip) }

        describe "#validate" do
          context "when meta.yml exists in the package" do
            before(:each) { allow(mocked_sip).to receive(:files).and_return(["meta.yml"]) }

            it "does not return errors" do
              expect(any_errors?(validator.validate)).to be_falsey
            end
          end
          context "when meta.yml does not exist in the package" do
            before(:each) { allow(mocked_sip).to receive(:files).and_return([]) }

            it "returns an appropriate error" do
              expect(human_messages(validator.validate)).to include(a_string_matching(/missing meta.yml/))
            end
          end
        end
      end

      describe WellFormed do
        describe '#validate' do
          context 'when meta.yml is well formed' do
            it 'does not return errors' do
              validator = described_class.new(SIP::SIP.new(sample_zip('default.zip')))
              expect(validator.validate.any_errors?).to be_falsey
            end
          end
          context 'when meta.yml is not well formed' do
            let(:validator) { described_class.new(SIP::SIP.new(sample_zip('bad_meta_yml.zip'))) }

            it 'returns an appropriate error' do
              expect(validator.validate.details).to include(a_string_matching(/Couldn't parse meta.yml/))
            end

            it 'has underlying details of the problem' do
              expect(validator.validate.first[:root_cause]).to match(/ tab /)
            end
          end
        end
      end
    end
  end
end
