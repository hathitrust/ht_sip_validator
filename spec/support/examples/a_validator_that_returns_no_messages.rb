# let(:validation) { Somevalidation.new }
shared_examples_for "a validation that returns no messages" do
  it "does not return any messages" do
    expect(validation.validate.length).to be(0)
  end
end
