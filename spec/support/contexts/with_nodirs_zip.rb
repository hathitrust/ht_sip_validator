require 'spec_helper'

shared_context 'with nodirs zip' do
  let(:zip_file) { File.join fixtures_path, 'sips', 'nodirs.zip' }
  let(:zip_checksums) do
    {
      '00000001.tif' => '93497fe31dba53314b47dc370bad9fc2',
      '00000001.txt' => '3c604c2f0e7634200784d1cfbb45c65d',
      '00000002.jp2' => 'bf5eac4b5bcd248b4d2ad7ad605527f1',
      '00000002.txt' => 'b5ef42830dea2c1867fb635dd32fcade',
      'meta.yml'     => '22e72420434af1b511c629ef42889298'
    }
  end
  let(:zip_meta) do
    {
      'capture_date' => Time.parse('2016-01-01T00:00:00-04:00'),
      'scanner_user' => 'University of Michigan'
    }
  end
  let(:zip_files) do
    %w(00000001.tif 00000001.txt 00000002.jp2
       00000002.txt checksum.md5 meta.yml)
  end
end
