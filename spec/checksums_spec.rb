require 'spec_helper'
require 'zip'
require 'ht_sip_validator/checksums'

FOO_CHECKSUM = '66d3b6e55fd94f1752bc8654335d8ff4'.freeze
BAR_CHECKSUM = 'c2223b5c324e395fd9f9bb249934ac87'.freeze

# specs for checksums
module HathiTrust
  describe Checksums do
    describe '#initialize' do
      it 'accepts a string' do
        sample = <<eot
#{FOO_CHECKSUM}  foo
#{BAR_CHECKSUM}  bar
eot
        expect(Checksums.new(sample).checksums).to eq('foo' => FOO_CHECKSUM,
                                                      'bar' => BAR_CHECKSUM)
      end

      it 'accepts an input stream from a zip file' do
        Zip::File.new(sample_zip) do |zip_file|
          zip_file.glob('**/checksum.md5').first
                  .get_input_stream do |file_stream|
            expect(Checksums.new(file_stream).checksums).to
            eq('00000001.tif' => '93497fe31dba53314b47dc370bad9fc2',
               '00000001.txt' => '3c604c2f0e7634200784d1cfbb45c65d',
               '00000002.jp2' => 'bf5eac4b5bcd248b4d2ad7ad605527f1',
               '00000002.txt' => 'b5ef42830dea2c1867fb635dd32fcade',
               'meta.yml'     => '22e72420434af1b511c629ef42889298')
          end
        end
      end

      it 'ignores comments' do
        sample = <<eot
# this is a comment
#{FOO_CHECKSUM}  foo
eot
        expect_foo_from_sample(sample)
      end

      it 'ignores trailing whitespace' do
        sample = "#{FOO_CHECKSUM}  foo "
        expect_foo_from_sample(sample)
      end

      it 'strips paths' do
        sample = "#{FOO_CHECKSUM}  /home/foo/bar/some/long/path/foo"
        expect_foo_from_sample(sample)
      end

      it 'handles windows-style checksums' do
        sample = FOO_CHECKSUM + ' *C:\Users\My Name\with\spaces \path\foo'
        expect_foo_from_sample(sample)
      end

      it 'lower-cases file names' do
        sample = FOO_CHECKSUM + '  Foo'
        expect_foo_from_sample(sample)
      end

      def expect_foo_from_sample(sample)
        expect(Checksums.new(sample).checksums).to eq('foo' => FOO_CHECKSUM)
      end
    end

    describe '#checksum_for' do
      it 'returns the checksum for a given file' do
        sample = <<eot
#{FOO_CHECKSUM}  foo
#{BAR_CHECKSUM}  bar
eot
        expect(Checksums.new(sample).checksum_for('foo')).to eq(FOO_CHECKSUM)
      end
    end
  end
end
