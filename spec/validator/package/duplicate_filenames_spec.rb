# frozen_string_literal: true

require "spec_helper"

describe HathiTrust::Validator::Package::DuplicateFilenames do
  let(:mocked_sip) { HathiTrust::SIP::SIP.new("") }
  let(:validator) { described_class.new(mocked_sip) }

  describe "#validate" do
    context "when package has unique filenames" do
      let(:path_list) do
        %w[foo/00000001.tif foo/checksum.md5 foo/meta.yml]
      end
      before(:each) { allow(mocked_sip).to receive(:paths).and_return(path_list) }

      it_behaves_like "a validator with a valid package"
      it_behaves_like "a validator that returns no messages"
    end

    context "when package has duplicate filenames in different paths" do
      let(:path_list) do
        %w[foo/00000001.tif bar/00000001.tif foo/checksum.md5 foo/meta.yml]
      end
      before(:each) { allow(mocked_sip).to receive(:paths).and_return(path_list) }

      it_behaves_like "a validator with an invalid package"

      it "returns an appropriate message" do
        expect(human_messages(validator.validate))
          .to include(a_string_matching(/foo\/00000001\.tif/))
      end
    end
  end
end
