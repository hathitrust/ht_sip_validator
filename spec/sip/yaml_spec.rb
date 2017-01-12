# frozen_string_literal: true
require "spec_helper"

# specs for HathiTrust submission package
module HathiTrust::SIP

  describe YAML do
    describe "#load" do
      include_context "with default zip"
      it "parses a string" do
        expect(YAML.load("thing")).to eq("thing")
      end

      it "doesn't parse times" do
        expect(YAML.load("time: 1970-01-01T00:00:00")).to eq("time" => "1970-01-01T00:00:00")
      end

      it "returns false when parsing an empty string" do
        expect(YAML.load("")).to be false
      end
    end
  end
end
