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
          let(:errors) do
            [validator.create_error(
              validation: :image_compression_date,
              human_readable: "An iso8601 combined date is required for image_compression_date in meta.yml.",
              extras: {filename: "meta.yml", actual: image_compression_date }
            )]
          end
          it "returns the errors" do
            expect(validator.validate).to eql(errors)
          end
        end

        context "when wrong format" do
          let(:capture_date) { "2007-11-19 08:25:02 -0600" }
          let(:image_compression_date) { "2010-03-30T05:43:25.1235000000Z" }
          let(:errors) do
            [
              validator.create_error(
                validation: "capture_date",
                human_readable: "An iso8601 combined date is required for capture_date in meta.yml.",
                extras: {filename: "meta.yml", actual: capture_date }),
              validator.create_error(
                validation: "image_compression_date",
                human_readable: "An iso8601 combined date is required for image_compression_date in meta.yml.",
                extras: {filename: "meta.yml", actual: image_compression_date })
            ]
          end
          it "returns the errors" do
            expect(validator.validate).to eql(errors)
          end
        end

        context "when impossible date" do
          let(:capture_date) { "2001-02-29T01:02:03-03:00" }
          let(:image_compression_date) { "2002-02-29T12:12:59Z" }
          let(:errors) do
            [
              validator.create_error(
                validation: "capture_date",
                human_readable: "The supplied date for capture_date in meta.yml is impossible.",
                extras: {filename: "meta.yml", actual: capture_date }),
              validator.create_error(
                validation: "image_compression_date",
                human_readable: "The supplied date for image_compression_date in meta.yml is impossible.",
                extras: {filename: "meta.yml", actual: image_compression_date })
            ]
          end
          it "returns the errors" do
            expect(validator.validate).to eql(errors)
          end
        end

        #%FT%T%:z

      end


    end
  end
end
