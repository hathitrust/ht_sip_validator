# frozen_string_literal: true

# let(:validator) { SomeValidator.new }
shared_examples_for "a validator with the correct interface" do
  it "can successfully #perform_validation" do
    expect { validator.perform_validation }.not_to raise_error
  end
end
