# frozen_string_literal: true
require "spec_helper"

shared_context "with duplicate filenames zip" do
  let(:zip_file) { File.join fixtures_path, "sips", "duplicate_filenames.zip" }
  let(:zip_paths) do
    %w(bar/ bar/00000001.tif bar/00000001.txt foo/ foo/00000001.tif
       foo/00000001.txt foo/checksum.md5 foo/meta.yml)
  end
end
