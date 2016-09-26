require 'spec_helper'

module HathiTrust
  module Validation

    describe MetaYmlExists do
      let(:mocked_sip) { SIP::SIP.new('') }
      subject(:validator) { described_class.new(mocked_sip) }

      describe '#validate' do
        context 'when meta.yml exists in the package' do
          before(:each) { allow(mocked_sip).to receive(:files).and_return(['meta.yml']) }
          it 'does not return errors' do
            expect(validator.validate.any_errors?).to be false
          end
        end
        context 'when meta.yml does not exist in the package' do
          before(:each) { allow(mocked_sip).to receive(:files).and_return([]) }
          it 'returns an appropriate error' do
            expect(validator.validate.human_messages).to include(a_string_matching(/missing meta.yml/))
          end
        end
      end
    end

  end
end
