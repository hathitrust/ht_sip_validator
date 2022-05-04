# frozen_string_literal: true

require "spec_helper"

describe HathiTrust::Validator::Package::ExtraFiles do
  let(:mocked_sip) { HathiTrust::SIP::SIP.new("") }
  let(:validator) { described_class.new(mocked_sip) }

  describe "#validate" do
    context "when package contains only checksum.md5 and meta.yml" do
      let(:file_list) do
        %w[checksum.md5 meta.yml]
      end
      before(:each) { allow(mocked_sip).to receive(:files).and_return(file_list) }

      it_behaves_like "a validator with a valid package"
      it_behaves_like "a validator that returns no messages"
    end

    context "when package contains foo.md5" do
      let(:file_list) { %w[foo.md5 checksum.md5 meta.yml] }
      before(:each) { allow(mocked_sip).to receive(:files).and_return(file_list) }

      it_behaves_like "a validator with warnings and only warnings"

      it "returns an appropriate message" do
        expect(human_messages(validator.validate))
          .to include(a_string_matching(/foo\.md5/))
      end
    end

    context "when package contains foo.yml" do
      let(:file_list) { %w[foo.yml checksum.md5 meta.yml] }
      before(:each) { allow(mocked_sip).to receive(:files).and_return(file_list) }

      it_behaves_like "a validator with warnings and only warnings"

      it "returns an appropriate message" do
        expect(human_messages(validator.validate))
          .to include(a_string_matching(/foo\.yml/))
      end
    end
  end
end
