# frozen_string_literal: true
require "spec_helper"

describe HathiTrust::Validator::Checksums::ExpectedValue do
  let(:mocked_sip) { HathiTrust::SIP::SIP.new("") }
  let(:mock_sums)  { instance_double("HathiTrust::SIP::Checksums") }
  let(:validator)  { described_class.new(mocked_sip) }
  let(:filehandle) { open_fixture("ocr", filename) }


  describe "#validate_file" do

		before do
			allow(mocked_sip).to receive(:checksums).and_return(mock_sums)
			allow(mock_sums).to receive(:checksum_for).with(filename).and_return(checksum_value)
		end

    context "with a file that has a matching value in package checksums" do
      let(:filename) { "utf8.txt" }
      let(:checksum_value) {"ed9ddac3ec25a5bd8a010be2e10ce121"}

      it_behaves_like "a validator with a valid file"
    end
     
    context "with a file that has mismatch with the package checksum" do
      let(:filename) { "utf8.txt" }
      let(:checksum_value) {"deadbeefdeadbeefdeadbeefdeadbeef"}

      it_behaves_like "a validator with an invalid file"

      it "emits an appropriate message" do
        expect(human_messages(validator.validate_file(filename, filehandle)))
          .to include(a_string_matching(/Checksum mismatch for/))
      end
    end

    context "with a file not listed in checksums" do
      let(:filename) { "utf8.txt" }
      let(:checksum_value) {nil}

      it_behaves_like "a validator with an invalid file"

      it "emits an appropriate message" do
        expect(human_messages(validator.validate_file(filename, filehandle)))
          .to include(a_string_matching(/Checksum missing for/))
      end
    end
  end

  describe "#should_validate?" do
    let(:exempt_filenames) { HathiTrust::Validator::Checksums::EXEMPT_FILENAMES }

    it "does not validate files in the exept list" do
      exempt_filenames.each do |filename|
        expect(validator.should_validate?(filename)).to be_falsey
      end
    end
  end
end


# Integration test
describe HathiTrust::Validator::Checksums::ExpectedValue do

  describe "validation of default package" do
    let(:default_sip) { HathiTrust::SIP::SIP.new("spec/fixtures/sips/default.zip") }
    let(:validator) { described_class.new(default_sip) }

    it "behaves like a validator with all valid files" do
      messages = []
      default_sip.each_file do |name, handle|
        messages << validator.validate_file(name, handle)
      end
      messages = messages.flatten
      expect(any_errors?(messages)).to be(false)
    end
  end

  describe "validation of mismatched checksum package" do
    let(:mismatch_sip) { HathiTrust::SIP::SIP.new("spec/fixtures/sips/mismatch_checksum.zip") }
    let(:validator) { described_class.new(mismatch_sip) }

    it "behaves like a validator with invalid files" do
      messages = []
      mismatch_sip.each_file do |name, handle|
        messages << validator.validate_file(name, handle)
      end
      messages = messages.flatten
      expect(any_errors?(messages)).to be(true)
    end
  end
end
