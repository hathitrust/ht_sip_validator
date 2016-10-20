
# let(:validation) { SomeValidator.new }
shared_examples_for "a validation with the correct interface" do
  it "can successfully #perform_validation" do
    expect { validation.perform_validation }.not_to raise_error
  end
end
