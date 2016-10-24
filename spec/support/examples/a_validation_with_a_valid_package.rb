
# frozen_string_literal: true
# let(:validation) { SomeValidator.new }
shared_examples_for "a validation with a valid package" do
  it "does not return errors" do
    expect(any_errors?(validation.validate)).to be false
  end
end
