require "spec_helper"

shared_context "with default zip" do
  let(:zip_file) { File.join fixtures_path, "sips", "default.zip" }
  let(:zip_result) {
    {
      '00000001.tif' => '93497fe31dba53314b47dc370bad9fc2',
      '00000001.txt' => '3c604c2f0e7634200784d1cfbb45c65d',
      '00000002.jp2' => 'bf5eac4b5bcd248b4d2ad7ad605527f1',
      '00000002.txt' => 'b5ef42830dea2c1867fb635dd32fcade',
      'meta.yml'     => '22e72420434af1b511c629ef42889298'
    }
  }
end