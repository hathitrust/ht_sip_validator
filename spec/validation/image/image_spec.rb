# frozen_string_literal: true
require "spec_helper"

describe HathiTrust::Validator::Image do

  subject {HathiTrust::Validator::Image}

  it "stores array of strings in IMG_FILE_EXTENSIONS" do
    expect(subject::IMG_FILE_EXTENSIONS).to be_a(Array)
    subject::IMG_FILE_EXTENSIONS.each do |item|
      expect(item).to be_a(String)
      expect(item).to match(/^\.[a-z0-9]{3}$/)
    end
  end

  describe "#image_files" do
    let(:file_extensions){ ['.bar', '.baz'] }
    let(:target_files) { %w(00000003.bar 00000002.baz 00000001.bar) }
    let(:other_files) { %w(00000001.txt 00000002.txt 00000003.txt checksum.md5 meta.yml) }
    let(:file_list) { other_files + target_files }

    before(:each) do
      stub_const("HathiTrust::Validator::Image::IMG_FILE_EXTENSIONS", file_extensions)
    end

    it 'only returns filenames with extensions define in IMG_FILE_EXTENSIONS' do
      returned_files = subject.image_files(file_list)
      expect(returned_files.count).to eq(target_files.count)
      expect(returned_files).to all( match(/\.ba[rz]$/) )
    end

    it 'returns sorted filenames' do
      returned_files = subject.image_files(file_list)
      expect(returned_files).to eq(target_files.sort)
    end

  end
end
