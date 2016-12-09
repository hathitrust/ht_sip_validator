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
      it_behaves_like "a text file validator"
    end
  end
end
