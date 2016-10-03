# let(:validator) { SomeValidator.new }

shared_examples_for "a validator with warnings and only warnings" do
  it "has at least one warning" do
    expect(validator.validate.any?(&:warning?)).to be_truthy
  end

  it "has only warnings" do
    expect(validator.validate.all?(&:warning?)).to be_truthy
  end
end
