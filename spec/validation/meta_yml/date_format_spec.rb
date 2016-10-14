# frozen_string_literal: true
require "spec_helper"

module HathiTrust
  module Validation
    module MetaYml

      describe DateFormat do
        let(:meta_yml) do
          { "capture_date" => capture_date,
            "image_compression_date" => image_compression_date }
        end
        let(:sip) { double(:sip, meta_yml: meta_yml) }
        subject(:validator) { described_class.new(double(:sip)) }

        let(:capture_date_error) do
          message_for(
            described_class.to_s,
            :capture_date,
            {filename: "meta.yml", actual: capture_date })
        end

        let(:image_compression_date_error) do
          message_for(
            described_class.to_s,
            :image_compression_date,
            {filename: "meta.yml", actual: image_compression_date })
        end

        context "when iso8601" do
          let(:capture_date) { "2016-12-08T01:02:03-05:00" }
          let(:image_compression_date) { "2000-02-29T12:12:59Z" }
          it "returns no errors" do
            expect(validator.validate).to eql([])
          end
        end

        context "when missing" do
          let(:capture_date) { "2016-12-08T01:02:03-05:00" }
          let(:image_compression_date) { nil }
          it "returns the errors" do
            expect(validator.validate)
              .to contain_exactly(image_compression_date_error)
          end
        end

        context "when wrong format" do
          let(:capture_date) { "2007-11-19 08:25:02 -0600" }
          let(:image_compression_date) { "2010-03-30T05:43:25.1235000000Z" }
          it "returns the errors" do
            expect(validator.validate)
              .to contain_exactly(capture_date_error, image_compression_date_error)
          end
        end

        context "when impossible date" do
          let(:capture_date) { "2001-02-29T01:02:03-03:00" }
          let(:image_compression_date) { "2002-02-29T12:12:59Z" }
          it "returns the errors" do
            expect(validator.validate)
              .to contain_exactly(capture_date_error, image_compression_date_error)
          end
        end

        #%FT%T%:z

      end


    end
  end
end
