# frozen_string_literal: true

require "spec_helper"

module HathiTrust
  describe Validator::MetaYml::DateFormat do
    let(:sip) do
      double(:sip, metadata: {
        "capture_date" => capture_date,
        "image_compression_date" => image_compression_date
      })
    end
    subject(:validator) { described_class.new(sip) }

    let(:capture_date_error) do
      Validator::Message.new(
        validator: described_class,
        validation_type: :capture_date,
        level: :error,
        human_message: "An iso8601 combined date (e.g 2016-12-08T01:02:03-05:00) is required for capture_date in meta.yml.",
        extras: {
          filename: "meta.yml",
          field: "capture_date",
          actual: capture_date
        }
      )
    end

    let(:image_compression_date_error) do
      Validator::Message.new(
        validator: described_class,
        validation_type: :image_compression_date,
        level: :error,
        human_message: "An iso8601 combined date (e.g 2016-12-08T01:02:03-05:00) is required for image_compression_date in meta.yml.",
        extras: {
          filename: "meta.yml",
          field: "image_compression_date",
          actual: image_compression_date
        }
      )
    end

    context "when iso8601" do
      let(:capture_date) { "2016-12-08T01:02:03-05:00" }
      let(:image_compression_date) { "2000-02-29T12:12:59Z" }

      it_behaves_like "a validator with the correct interface"
      it_behaves_like "a validator with a valid package"
      it_behaves_like "a validator that returns no messages"
    end

    context "when missing" do
      let(:capture_date) { "2016-12-08T01:02:03-05:00" }
      let(:image_compression_date) { nil }

      it_behaves_like "a validator with the correct interface"
      it_behaves_like "a validator with a valid package"
      it_behaves_like "a validator that returns no messages"
    end

    context "when wrong format" do
      let(:capture_date) { "2007-11-19 08:25:02 -0600" }
      let(:image_compression_date) { "2010-03-30T05:43:25.1235000000Z" }

      it_behaves_like "a validator with an invalid package"

      it "returns two appropriate messages" do
        messages = validator.validate
        expect(messages.size).to eql(2)
        expect(messages.first).to eql(capture_date_error)
        expect(messages.last).to eql(image_compression_date_error)
      end
    end

    context "when impossible date" do
      let(:capture_date) { "2001-02-29T01:02:03-03:00" }
      let(:image_compression_date) { "2002-02-29T12:12:59Z" }

      it_behaves_like "a validator with an invalid package"

      it "returns an appropriate message" do
        messages = validator.validate
        expect(messages.size).to eql(2)
        expect(messages.first).to eql(capture_date_error)
        expect(messages.last).to eql(image_compression_date_error)
      end
    end

    context "when missing leading zeroes" do
      let(:capture_date) { "2001-2-28T1:02:03-3:00" }
      let(:image_compression_date) { "2002-2-28T12:12:59-3:00" }

      it_behaves_like "a validator with an invalid package"

      it "returns an appropriate message" do
        messages = validator.validate
        expect(messages.size).to eql(2)
        expect(messages.first).to eql(capture_date_error)
        expect(messages.last).to eql(image_compression_date_error)
      end
    end
  end
end
