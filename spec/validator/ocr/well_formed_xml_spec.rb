# frozen_string_literal: true

require "spec_helper"

module HathiTrust
  describe Validator::OCR::WellFormedXML do
    let(:mocked_sip) { SIP::SIP.new("") }
    let(:validator) { described_class.new(mocked_sip) }
    let(:filehandle) { open_fixture("ocr", filename) }

    describe "#validate_file" do
      context "with a well-formed xml file" do
        let(:filename) { "wellformed.xml" }
        it_behaves_like "a validator with a valid file"
        it_behaves_like "a file validator that returns no messages"
      end

      context "with a malformed xml file" do
        let(:filename) { "malformed.xml" }
        it_behaves_like "a validator with an invalid file"
        it "returns an appropriate message" do
          expect(human_messages(validator.validate_file(filename, filehandle)))
            .to include(a_string_matching(/not well-formed/))
        end
      end
    end

    describe "#should_validate?" do
      it "does not validate text files" do
        expect(validator.should_validate?("00000001.txt")).to be false
      end

      it "validates html files" do
        expect(validator.should_validate?("00000001.html")).to be true
      end

      it "validates xml files" do
        expect(validator.should_validate?("00000001.xml")).to be true
      end

      it "does not validate tif files" do
        expect(validator.should_validate?("00000001.tif")).to be false
      end

      it "does not validate jp2 files" do
        expect(validator.should_validate?("00000001.jp2")).to be false
      end
    end
  end
end
