

# frozen_string_literal: true
shared_examples_for "a validator with warnings and only warnings" do
  it "has at least one warning" do
    expect(validator.validate.any?(&:warning?)).to be true
  end

  it "has only warnings" do
    expect(validator.validate.all?(&:warning?)).to be true
  end
end
