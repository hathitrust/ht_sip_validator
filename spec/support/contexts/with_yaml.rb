# frozen_string_literal: true
require "spec_helper"

shared_context "with yaml fixtures" do
  let(:valid_yaml) { HathiTrust::SIP::YAML.load("capture_date: 2013-11-01T12:31:00-05:00") }
  let(:invalid_yaml) { HathiTrust::SIP::YAML.load("capture_elephant: do it.") }
end
