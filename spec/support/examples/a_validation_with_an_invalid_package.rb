
# frozen_string_literal: true
# let(:validator) { SomeValidator.new }
shared_examples_for "a validator with an invalid package" do
  it "returns at least one Message" do
    expect(validator.validate).not_to be_empty
  end

  it "returns a collection of Messages" do
    expect(validator.validate).to all(be_an_instance_of(HathiTrust::Validator::Message))
  end

  it "return errors" do
    expect(any_errors?(validator.validate)).to be true
  end
end
