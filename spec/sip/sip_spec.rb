# frozen_string_literal: true
require "spec_helper"

# specs for HathiTrust submission package
module HathiTrust::SIP

  describe FILE_GROUP_EXTENSIONS do
    [:image, :coord_ocr, :ocr].each do |group|
      it "stores array of strings in FILE_GROUP_EXTENSIONS[#{group}]" do
        expect(subject[group]).to be_a(Array)
        subject[group].each do |item|
          expect(item).to be_a(String)
          expect(item).to match(/^\.[a-z0-9]{3,4}$/)
        end
      end
    end
  end

  describe SIP do
    describe "#initialize" do
      include_context "with default zip"
      it "accepts a zip file" do
        expect(described_class.new(zip_file)).not_to be_nil
      end
    end

    describe "#files" do
      include_context "with default zip"
      it "returns a list of files inside the zip" do
        expect(described_class.new(zip_file).files.sort).to eq(zip_files)
      end
    end

    describe "#paths" do
      context "with a well-formed zip" do
        include_context "with default zip"
        it "returns a list of all paths in the zip" do
          expect(described_class.new(zip_file).paths.sort).to eql(zip_paths)
        end
      end

      context "with a zip with duplicate filenames" do
        include_context "with duplicate filenames zip"
        it "returns a list of all paths in the zip" do
          expect(described_class.new(zip_file).paths.sort).to eql(zip_paths)
        end
      end
    end

    describe "#metadata" do
      context "with a well-formed zip" do
        include_context "with default zip"
        it "parses meta.yml" do
          expect(described_class.new(zip_file).metadata).to eql(zip_meta)
        end
      end

      context "with directory-free zip" do
        include_context "with nodirs zip"
        it "parses meta.yml" do
          expect(described_class.new(zip_file).metadata).to eql(zip_meta)
        end
      end

      context "with zip with deeply nested folder names" do
        include_context "with deeply_nested zip"
        it "parses meta.yml" do
          expect(described_class.new(zip_file).metadata).to eql(zip_meta)
        end
      end

      context "with zip missing meta.yml" do
        include_context "with empty zip"
        it "returns an empty hash" do
          expect(described_class.new(zip_file).metadata).to eql(zip_meta)
        end
      end

      context "with an empty meta.yml file" do
        include_context "with zip with empty meta.yml"
        it "returns an empty hash" do
          expect(described_class.new(zip_file).metadata).to eql(zip_meta)
        end
      end
    end

    describe "#checksums" do
      context "with a well-formed zip" do
        include_context "with default zip"
        it "returns a hash of filenames to checksums" do
          expect(described_class.new(zip_file).checksums).to be_a Checksums
        end
      end

      context "with zip missing checksum.md5" do
        include_context "with empty zip"
        it "returns an empty hash" do
          expect(described_class.new(zip_file).checksums.checksums).to eql({})
        end
      end
    end

    describe "#extract" do
      include_context "with default zip"
      it "extracts the files to a temp directory" do
        described_class.new(zip_file).extract do |dir|
          zip_files.each do |file_name|
            expect(File.exist?(File.join(dir, file_name))).to be_truthy
          end
        end
      end

      it "cleans up the directory after extraction" do
        dir_saved = nil
        described_class.new(zip_file).extract {|dir| dir_saved = dir }
        expect(dir_saved).not_to be_empty
        expect(File.exist?(dir_saved)).to be_falsey
      end
    end

    describe "#group_files" do
      let(:file_extensions) { [".bar", ".baz"] }
      let(:target_files) { %w(00000003.jp2 00000002.tif 00000001.jp2) }
      let(:other_files) { %w(00000001.txt 00000002.txt 00000003.txt checksum.md5 meta.yml) }
      let(:file_list) { other_files + target_files }
      subject { SIP.new("") }

      before(:each) do
        allow(subject).to receive(:files).and_return(file_list)
      end

      it "only returns filenames from the appropriate group" do
        returned_files = subject.group_files(:image)
        expect(returned_files.count).to eq(target_files.count)
        expect(returned_files).to all(match(/\.(jp2|tif)$/))
      end

      it "returns sorted filenames" do
        returned_files = subject.group_files(:image)
        expect(returned_files).to eq(target_files.sort)
      end

      it "raises ArgumentError for a nonexistent group" do
        expect { subject.group_files(:ponies) }.to raise_error(ArgumentError)
      end
    end

    describe "#each_file" do
      include_context "with default zip"

      it "yields the filename and a filehandle for each file in the zip" do
        sip = described_class.new(zip_file)
        expected_args = sip.files.map {|filename| [filename, Zip::InputStream] }
        expect {|b| sip.each_file(&b) }.to yield_successive_args(*expected_args)
      end
    end
  end
end
