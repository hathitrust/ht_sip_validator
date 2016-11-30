# frozen_string_literal: true
require "spec_helper"

module HathiTrust
  describe Validator::OCR::UTF8 do
    let(:mocked_sip) { SIP::SIP.new("") }
    let(:validator) { described_class.new(mocked_sip) }
    let(:filehandle) { open_fixture("ocr", filename) }

    describe "#validate_file" do
      context "with a utf-8 text file" do
        let(:filename) { "utf8.txt" }
        it_behaves_like "a validator with a valid file"
        it_behaves_like "a file validator that returns no messages"
      end

      context "with a utf-8 xml file" do
        let(:filename) { "utf8.xml" }
        it_behaves_like "a validator with a valid file"
        it_behaves_like "a file validator that returns no messages"
      end

      context "with a utf-16 xml file" do
        let(:filename) { "utf16.xml" }
        it_behaves_like "a validator with an invalid file"
        it "returns an appropriate message" do
          expect(human_messages(validator.validate_file(filename, filehandle)))
            .to include(a_string_matching(/utf16\.xml/))
        end
      end

      context "with a iso8859 text file" do
        let(:filename) { "iso8859.txt" }
        it_behaves_like "a validator with an invalid file"
        it "returns an appropriate message" do
          expect(human_messages(validator.validate_file(filename, filehandle)))
            .to include(a_string_matching(/iso8859\.txt/))
        end
      end
    end

    describe "#should_validate?" do
      it "validates text files" do
        expect(validator.should_validate?("00000001.txt")).to be true
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
