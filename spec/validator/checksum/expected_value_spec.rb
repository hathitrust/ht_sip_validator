# frozen_string_literal: true
require "spec_helper"

describe HathiTrust::Validator::Checksums::ExpectedValue do
  let(:mocked_sip) { HathiTrust::SIP::SIP.new("") }
  let(:exempt_filenames) { HathiTrust::Validator::Checksums::EXEMPT_FILENAMES }
  let(:mock_checksums) { instance_double("HathiTrust::SIP::Checksums") }
  let(:validator) { described_class.new(mocked_sip) }

  before(:each) do
    allow(mocked_sip).to receive(:files).and_return(file_list) 
    allow(mocked_sip).to receive(:checksums).and_return(mock_checksums) 
    allow(mock_checksums).to receive(:checksum_for).with("foo").and_return(foo_checksums_value)
    allow(validator).to receive(:calculated_checksum_for).with("foo").and_return(foo_calculated_value)
  end

  describe "#validate" do
    context "when checksums file values match calculated values" do
      let(:file_list) { ['foo'] + exempt_filenames }
      let(:foo_checksums_value)  { 'deadbeefdeadbeefdeadbeefdeadbeef' }
      let(:foo_calculated_value) { 'deadbeefdeadbeefdeadbeefdeadbeef' }

      it "only checks files that should have a checksum" do
        expect(validator).to receive(:calculated_checksum_for).once
        validator.validate
      end
    end

    context "when checksums file values do not match calculated values" do
      let(:file_list) { ['foo'] + exempt_filenames }
      let(:foo_checksums_value)  { 'deadbeefdeadbeefdeadbeefdeadbeef' }
      let(:foo_calculated_value) { '1234567890abcdef1234567890abcdef' }
      
      it_behaves_like "a validator with an invalid package"

      it "returns an appropriate error" do
        expect(human_messages(validator.validate))
          .to include(a_string_matching(/Checksum mismatch for/))
      end
    end

    context "when checksums file is missing a value for a file" do
      let(:file_list) { ['foo', 'bar'] + exempt_filenames }
      let(:foo_checksums_value)   { 'deadbeefdeadbeefdeadbeefdeadbeef' }
      let(:foo_calculated_value)  { '1234567890abcdef1234567890abcdef' }
      let(:bar_calculated_value)  { 'deadbeefdeadbeefdeadbeefdeadbeef' }
      
      before(:each) do
        allow(mock_checksums).to receive(:checksum_for).with("bar").and_return(nil)
        allow(validator).to receive(:calculated_checksum_for).with("bar").and_return(bar_calculated_value)
      end

      it_behaves_like "a validator with an invalid package"

      it "returns an appropriate error" do
        expect(human_messages(validator.validate))
          .to include(a_string_matching(/Checksum mismatch for/))
      end
    end
  end
end

# Integration test
describe HathiTrust::Validator::Checksums::ExpectedValue do

  describe "validation of default package" do
    let(:default_sip) { HathiTrust::SIP::SIP.new("spec/fixtures/sips/default.zip") }
    let(:validator) { described_class.new(default_sip) }

    it_behaves_like "a validator with a valid package"
    it_behaves_like "a validator that returns no messages"
  end

  describe "validation of mismatched checksum package" do
    let(:mismatch_sip) { HathiTrust::SIP::SIP.new("spec/fixtures/sips/mismatch_checksum.zip") }
    let(:validator) { described_class.new(mismatch_sip) }

    it_behaves_like "a validator with an invalid package"
    it "returns an appropriate error" do
      expect(human_messages(validator.validate))
        .to include(a_string_matching(/Checksum mismatch for/))
    end
  end
end
