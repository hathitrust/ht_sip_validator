# frozen_string_literal: true
require "spec_helper"

shared_context "with metadata fixtures" do
  let(:valid_metadata) { { "capture_date" => "2013-11-01T12:31:00-05:00" } }
  let(:invalid_metadata) { { "capture_elephant" => "do it." } }
end
