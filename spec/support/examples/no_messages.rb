# frozen_string_literal: true
# let(:validator) { Somevalidator.new }
shared_examples_for "a validator that returns no messages" do
  it "does not return any messages" do
    expect(validator.validate.length).to be(0)
  end
end

# let(:validator) { SomeValidator.new }
# let(:filehandle) { File.new('somefile.txt') }
# let(:filename) { 'somefile.txt' }
shared_examples_for "a file validator that returns no messages" do
  it "does not return any messages" do
    expect(validator.validate_file(filename,filehandle).length).to be(0)
  end
end
