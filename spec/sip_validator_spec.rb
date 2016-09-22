require 'spec_helper'
require 'ht_sip_validator/sip_validator'
require 'ht_sip_validator/base_validator'

# specs for HathiTrust SIP validator service
module HathiTrust
  describe SIPValidator do
    describe '#initialize' do
      it "accepts a path to a config.yml file" do
        expect(SIPValidator.new(File.new(File.join(config_path,"default.yml")))).not_to be_nil
      end
    end

    describe '#validate' do
      it "runs the validators in the given config" do
        volume = SubmissionPackage.new(sample_zip)
        expect_any_instance_of(BaseValidator).to receive(:valid?).and_call_original

        validator = SIPValidator.new("package_checks: ['BaseValidator']")
        validator.validate(volume)
      end
    end
  end
end
