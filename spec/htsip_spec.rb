require 'spec_helper'
require 'ht_sip_validator/htsip'

SAMPLE_FILES = %w(00000001.tif 00000001.txt 00000002.jp2
                  00000002.txt checksum.md5 meta.yml ).freeze

# specs for HathiTrust submission package
module HathiTrust
  describe SubmissionPackage do
    describe '#initialize' do
      it 'accepts a zip file' do
        expect(sample_sip).not_to be_nil
      end
    end

    describe '#files' do
      it 'returns a list of files inside the zip' do
        expect(sample_sip.files.sort).to eq(SAMPLE_FILES)
      end
    end

    describe '#meta_yaml' do
      it 'parses meta.yml from the zip' do
        expect(sample_sip.meta_yml).to eq(
          'capture_date' => Time.parse('2016-01-01T00:00:00-04:00'),
          'scanner_user' => 'University of Michigan'
        )
      end

      it 'finds meta.yml at the root of the zip' do
        expect(sample_sip('nodirs.zip').meta_yml).to be_a Hash
      end

      it 'finds meta.yml in a zip with deeply nested folder names' do
        expect(sample_sip('deeply_nested.zip').meta_yml).to be_a Hash
      end
    end

    describe '#checksums' do
      it 'returns a hash of filenames to checksums' do
        expect(sample_sip.checksums).to be_a Checksums
      end
    end

    describe '#extract' do
      it 'extracts the files to a temp directory' do
        sample_sip.extract do |dir|
          SAMPLE_FILES.each do |file_name|
            expect(File.exist?(File.join(dir, file_name))).to be_truthy
          end
        end
      end

      it 'cleans up the directory after extraction' do
        dir_saved = nil
        sample_sip.extract { |dir| dir_saved = dir }
        expect(dir_saved).not_to be_empty
        expect(File.exist?(dir_saved)).to be_falsey
      end
    end

    def sample_sip(zip = 'default.zip')
      SubmissionPackage.new(sample_zip(zip))
    end
  end
end
