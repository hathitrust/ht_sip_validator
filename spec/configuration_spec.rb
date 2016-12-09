# frozen_string_literal: true
require "spec_helper"

# specs for HathiTrust SIP validator service
module HathiTrust

  class Validator::ConfigTestValidator; end

  describe Configuration do
    describe "#initialize" do
      it "reads from a file handle" do
        config = described_class.new(double(:io, read: "foo\n"))
        expect(config.config).to eql("foo")
      end

      it "reads yaml" do
        config = described_class.new(double(:io, read: "---\nfoo: bar\n"))
        expect(config.config).to eql("foo" => "bar")
      end
    end

    describe "#package_checks" do
      it "handles an empty configuration" do
        config = described_class.new(double(:io, read: "---\npackage_checks:\n"))
        expect(config.package_checks).to eql([])
      end

      it "resolves a check named ConfigTestValidator" do
        file = double(:io, read: "---\npackage_checks:\n - ConfigTestValidator: []\n")
        config = described_class.new(file)
        expect(config.package_checks.map(&:validator_class))
          .to eql([Validator::ConfigTestValidator])
      end
    end

    describe "#file_checks" do
      it "handles an empty configuration" do
        config = described_class.new(double(:io, read: "---\nfile_checks:\n"))
        expect(config.file_checks).to eql([])
      end

      it "resolves a check named ConfigTestValidator" do
        file = double(:io, read: "---\nfile_checks:\n - ConfigTestValidator: []\n")
        config = described_class.new(file)
        expect(config.file_checks.map(&:validator_class))
          .to eql([Validator::ConfigTestValidator])
      end
    end
  end

end
