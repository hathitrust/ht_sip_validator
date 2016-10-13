
# let(:validator) { SomeValidator.new }
shared_examples_for "a validator with an invalid package" do
  it "returns a collection of Messages" do
    expect(validator.validate).to all(be_an_instance_of(HathiTrust::Validation::Message))
  end
end