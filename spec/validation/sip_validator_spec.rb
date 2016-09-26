require 'spec_helper'

# specs for HathiTrust SIP validator service
module HathiTrust
  module Validation
    describe SIPValidator do
      describe '#initialize' do
        it 'accepts a path to a config.yml file' do
          expect(described_class.new(File.new(File.join(config_path, 'default.yml')))).not_to be_nil
        end
      end

      describe '#validate' do
        it 'runs the validators in the given config' do
          volume = SIP::SIP.new(sample_zip)
          expect_any_instance_of(Base).to receive(:validate).and_call_original

          validator = described_class.new("package_checks: ['Validation::Base']")
          validator.validate(volume)
        end
      end
    end
  end
end
