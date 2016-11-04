# frozen_string_literal: true
require "spec_helper"

shared_context "with empty zip" do
  let(:zip_file) { File.join fixtures_path, "sips", "empty.zip" }
  let(:zip_checksums) do
    {
    }
  end
  let(:zip_meta) do
    {
    }
  end
  let(:zip_files) do
    %w()
  end
end
