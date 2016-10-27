
# frozen_string_literal: true
# let(:validation) { SomeValidator.new }
shared_examples_for "a validation with an invalid package" do
  it "returns at least one Message" do
    expect(validation.validate).not_to be_empty
  end

  it "returns a collection of Messages" do
    expect(validation.validate).to all(be_an_instance_of(HathiTrust::Validation::Message))
  end

  it "return errors" do
    expect(any_errors?(validation.validate)).to be true
  end
end
