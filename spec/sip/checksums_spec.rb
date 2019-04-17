# frozen_string_literal: true
require "spec_helper"
require "zip"

module HathiTrust::SIP
  describe Checksums do
    let(:foo_md5) { "66d3b6e55fd94f1752bc8654335d8ff4" }
    let(:bar_md5) { "c2223b5c324e395fd9f9bb249934ac87" }
    let(:foo_result) { { "foo" => foo_md5 } }
    let(:bar_result) { { "bar" => bar_md5 } }
    let(:foobar_result) { foo_result.merge(bar_result) }

    describe "#initialize" do
      let(:sample) { "#{foo_md5} foo\n#{bar_md5} bar\n" }
      let(:commented_sample) { "# this is a comment\n#{sample}" }
      let(:trailing_whitespace_sample) { "#{foo_md5} foo  " }
      let(:path_sample) { "#{foo_md5} /home/foo/bar/some/long/path/foo" }
      let(:windows_sample) { foo_md5 + ' *C:\Users\My Name\with\spaces \path\foo' }
      let(:titlecase_sample) { "#{foo_md5} Foo" }
      let(:powershell_sample) { File.open(File.dirname(__FILE__) + "/../fixtures/powershell_checksum.md5", "rb").read() }
      let(:backwards_sample) { "foo  #{foo_md5}" }
      let(:delimited_sample) { "#{foo_md5},foo"}
      let(:uppercase_sample) { "#{foo_md5.upcase}  foo" }

      include_context "with default zip"
      let(:zip_stream) do
        Zip::File.new(zip_file).glob("**/checksum.md5").first.get_input_stream.read
      end

      it "accepts a string" do
        expect(described_class.new(sample).checksums).to eql(foobar_result)
      end
      it "ignores comments" do
        expect(described_class.new(commented_sample).checksums).to eql(foobar_result)
      end
      it "ignores trailing whitespace" do
        expect(described_class.new(trailing_whitespace_sample).checksums).to eql(foo_result)
      end
      it "strips paths" do
        expect(described_class.new(path_sample).checksums).to eql(foo_result)
      end
      it "handles windows-style checksums" do
        expect(described_class.new(windows_sample).checksums).to eql(foo_result)
      end
      it "lower-cases file names" do
        expect(described_class.new(titlecase_sample).checksums).to eql(foo_result)
      end
      it "accepts an input stream from a zip file" do
        expect(described_class.new(zip_stream).checksums).to eql(zip_checksums)
      end

      it "can read a checksum file created with powershell (utf-16)" do
        expect(described_class.new(powershell_sample).checksums).to include("00000001.html" => "602c5866bb2da48d7301322d3758f6c3")
      end

      it "accepts checksums formatted with filename first" do
        expect(described_class.new(backwards_sample).checksums).to eql(foo_result)
      end

      it "lower-cases checksums" do
        expect(described_class.new(uppercase_sample).checksums).to eql(foo_result)
      end

      it "accepts checksums formatted as csv" do
        expect(described_class.new(delimited_sample).checksums).to eql(foo_result)
      end

    end

    describe "#checksum_for" do
      let(:sample) { "#{foo_md5} foo\n#{bar_md5} bar\n" }
      let(:subject) { described_class.new(sample) }
      it "returns the checksum for a given file" do
        expect(subject.checksum_for("foo")).to eql(foo_md5)
      end
    end
  end
end
