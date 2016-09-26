require 'spec_helper'

module HathiTrust
  module Validation
    describe Messages do
      describe '#any_errors?' do
        it 'is true if there are errors' do
          msgs = described_class.new
          msgs.push Message.new(validator: :x, validation: :y, level: Message::ERROR, human_message: "z")
          msgs.push(level: :error, detail: 'it is an error')
          expect(msgs.any_errors?).to be_truthy
        end

        it 'is false if there are no errors' do
          expect(described_class.new.any_errors?).to be_falsey
        end
      end
    end
  end
end
