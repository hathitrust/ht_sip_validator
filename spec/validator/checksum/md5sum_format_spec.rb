
# frozen_string_literal: true
require "spec_helper"

describe HathiTrust::Validator::Checksums::MD5SumFormat do
  let(:mocked_sip) { instance_double("HathiTrust::SIP::SIP") }

  before(:each) do
    allow(mocked_sip).to receive(:raw_checksums).and_return(checksums)
  end

  let(:validator) { described_class.new(mocked_sip) }

  context "with checksums created with md5sum" do
    let(:checksums) do
      <<~EOT
        66d3b6e55fd94f1752bc8654335d8ff4  foo.txt
        c2223b5c324e395fd9f9bb249934ac87 *bar.txt
      EOT
    end
    it_behaves_like "a validator with a valid package"
    it_behaves_like "a validator that returns no messages"
  end

  context "with checksums with DOS line endings" do
    let(:checksums) do
      <<~EOT
        66d3b6e55fd94f1752bc8654335d8ff4  foo.txt\r
        c2223b5c324e395fd9f9bb249934ac87 *bar.txt\r
        EOT
    end

    it_behaves_like "a validator with a valid package"
    it_behaves_like "a validator that returns no messages"
  end

  context "with UTF-16 checksums" do
    let(:checksums) { File.open(File.dirname(__FILE__) + "/../../fixtures/powershell_checksum.md5", "rb").read() }

    it_behaves_like "a validator with warnings and only warnings"
  end

  context "with checksums that include a comment" do
    let(:checksums) do
      <<~EOT
        # this is a comment
        66d3b6e55fd94f1752bc8654335d8ff4  foo.txt
        c2223b5c324e395fd9f9bb249934ac87 *bar.txt
      EOT
    end

    it_behaves_like "a validator with a valid package"
    it_behaves_like "a validator that returns no messages"
  end

  context "with checksums that include empty lines" do
    let(:checksums) do
      <<~EOT

        66d3b6e55fd94f1752bc8654335d8ff4  foo.txt
        c2223b5c324e395fd9f9bb249934ac87 *bar.txt

      EOT
    end

    it_behaves_like "a validator with a valid package"
    it_behaves_like "a validator that returns no messages"
  end

  context "with checksums in the wrong order" do
    let(:checksums) do
      <<~EOT
        foo.txt 66d3b6e55fd94f1752bc8654335d8ff4
      EOT
    end

    it_behaves_like "a validator with warnings and only warnings"
  end

  context "with comma-delimited checksums" do
    let(:checksums) do
      <<~EOT
        66d3b6e55fd94f1752bc8654335d8ff4,foo.txt
      EOT
    end

    it_behaves_like "a validator with warnings and only warnings"
  end
end
