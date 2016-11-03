
# frozen_string_literal: true
# let(:validator) { SomeValidator.new }
shared_examples_for "a validator with a valid package" do
  it "does not return errors" do
    expect(any_errors?(validator.validate)).to be false
  end
end
