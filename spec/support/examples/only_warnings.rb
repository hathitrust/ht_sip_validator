

# frozen_string_literal: true
shared_examples_for "a validation with warnings and only warnings" do
  it "has at least one warning" do
    expect(validation.validate.any?(&:warning?)).to be true
  end

  it "has only warnings" do
    expect(validation.validate.all?(&:warning?)).to be true
  end
end
