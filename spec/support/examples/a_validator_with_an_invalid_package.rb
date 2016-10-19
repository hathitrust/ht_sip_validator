
# let(:validation) { SomeValidator.new }
shared_examples_for "a validation with an invalid package" do
  it "returns a collection of Messages" do
    expect(validation.validate).to all(be_an_instance_of(HathiTrust::Validation::Message))
  end
end
