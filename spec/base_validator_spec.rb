require 'spec_helper'
require 'ht_sip_validator/base_validator'

module HathiTrust
  describe BaseValidator do
    subject(:validator) { BaseValidator.new(SubmissionPackage.new("")) }
    describe '#errors' do
      it "raises an exception when called without validating" do
        expect { validator.errors }.to raise_error(RuntimeError)
      end
    end

    describe '#warnings' do
      it "raises an exception when called without validating" do
        expect { validator.errors }.to raise_error(RuntimeError)
      end
    end
    
  end
end


