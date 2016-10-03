# frozen_string_literal: true
require "spec_helper"

module HathiTrust
  module Validation

    shared_examples_for "a validator with a valid package" do
      it "does not return errors" do
        expect(any_errors?(validator.validate)).to be_falsey
      end
    end

    shared_examples_for "a validator with an invalid package" do
      it "returns a collection of Messages" do
        expect(validator.validate).to all(be_an_instance_of(Message))
      end
    end

    module MetaYml
      describe Exists do
        let(:mocked_sip) { SIP::SIP.new("") }

        subject(:validator) { described_class.new(mocked_sip) }

        describe "#validate" do
          context "when meta.yml exists in the package" do
            before(:each) { allow(mocked_sip).to receive(:files).and_return(["meta.yml"]) }
            it_behaves_like "a validator with a valid package"
          end

          context "when meta.yml does not exist in the package" do
            before(:each) { allow(mocked_sip).to receive(:files).and_return([]) }

            it_behaves_like "a validator with an invalid package"

            it "returns an appropriate error" do
              expect(human_messages(validator.validate))
                .to include(a_string_matching(/missing meta.yml/))
            end
          end
        end
      end

      describe WellFormed do
        describe "#validate" do
          context "when meta.yml is well formed" do
            subject(:validator) { described_class.new(SIP::SIP.new(sample_zip("default.zip"))) }

            it_behaves_like "a validator with a valid package"
          end
          context "when meta.yml is not well formed" do
            subject(:validator) do
              described_class.new(SIP::SIP.new(sample_zip("bad_meta_yml.zip")))
            end

            it_behaves_like "a validator with an invalid package"

            it "returns an appropriate error" do
              expect(human_messages(validator.validate))
                .to include(a_string_matching(/Couldn't parse meta.yml/))
            end

            it "has underlying details of the problem" do
              expect(validator.validate.map(&:root_cause))
                .to include(a_string_matching(/ tab /))
            end
          end
        end
      end

      describe RequiredKeys do
        def valid_yaml
          YAML.load("capture_date: 2013-11-01T12:31:00-05:00")
        end

        def invalid_yaml
          YAML.load("capture_elephant: do it.")
        end

        describe "#validate" do
          let(:mocked_sip) { SIP::SIP.new("") }
          subject(:validator) { described_class.new(mocked_sip) }

          context "when meta.yml has capture_date" do
            before(:each) { allow(mocked_sip).to receive(:meta_yml) .and_return(valid_yaml) }

            it_behaves_like "a validator with a valid package"
          end

          context "when meta.yml does not have capture_date" do
            before(:each) { allow(mocked_sip).to receive(:meta_yml) .and_return(invalid_yaml) }

            it_behaves_like "a validator with an invalid package"

            it "returns an appropriate error" do
              expect(human_messages(validator.validate))
                .to include(a_string_matching(/capture_date/))
            end
          end
        end
      end
    end
  end
end
