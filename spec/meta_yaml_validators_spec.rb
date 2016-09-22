require 'spec_helper'
require 'ht_sip_validator/meta_yml_validators'

module HathiTrust
  module MetaYmlValidators
    describe ExistsValidator do
      let(:mocked_sip) { SubmissionPackage.new('') }
      subject(:validator) { ExistsValidator.new(mocked_sip) }

      context 'when meta.yml exists in the package' do
        before(:each) { allow(mocked_sip).to receive(:files).and_return(['meta.yml']) }
        it { is_expected.to be_valid }
      end

      context 'when meta.yml does not exist in the package' do
        before(:each) { allow(mocked_sip).to receive(:files).and_return([]) }
        it { is_expected.not_to be_valid }
        it 'returns an appropriate error' do
          validator.valid?
          expect(validator.errors).to include(a_string_matching(/missing meta\.yml/))
        end
      end
    end
  end
end
