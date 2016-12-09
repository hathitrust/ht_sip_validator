
# frozen_string_literal: true
# let(:validator) { SomeValidator.new }
shared_examples_for "a validator with a valid package" do
  it "does not return errors" do
    expect(any_errors?(validator.validate)).to be false
  end
end

# let(:validator) { SomeValidator.new }
# let(:filehandle) { File.new('somefile.txt') }
# let(:filename) { 'somefile.txt' }
shared_examples_for "a validator with a valid file" do
  it "does not return errors" do
    expect(any_errors?(validator.validate_file(filename,filehandle))).to be false
  end
end
