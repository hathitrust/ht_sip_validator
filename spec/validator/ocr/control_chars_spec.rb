# frozen_string_literal: true
require "spec_helper"

module HathiTrust
  describe Validator::OCR::ControlChars do
    let(:mocked_sip) { SIP::SIP.new("") }
    let(:validator) { described_class.new(mocked_sip) }
    let(:filehandle) { open_fixture("ocr", filename) }

    describe "#validate_file" do
      context "with a utf-8 text file" do
        let(:filename) { "utf8.txt" }
        it_behaves_like "a validator with a valid file"
        it_behaves_like "a file validator that returns no messages"
      end

      context "with a utf-8 text file with DOS line endings" do
        let(:filename) { "utf8-dos.txt" }
        it_behaves_like "a validator with a valid file"
        it_behaves_like "a file validator that returns no messages"
      end

      context "with a text file with control characters" do
        let(:filename) { "controlchars.txt" }
        it_behaves_like "a validator with an invalid file"
        it "returns an appropriate message" do
          expect(human_messages(validator.validate_file(filename, filehandle)))
            .to include(a_string_matching(/controlchars.txt/))
        end
      end
    end

    describe "#should_validate?" do
      it_behaves_like "a text file validator"
    end
  end
end
