# frozen_string_literal: true

# let(:validator) { SomeValidator.new }
shared_examples_for "a text file validator" do
  it "validates text files" do
    expect(validator.should_validate?("00000001.txt")).to be true
  end

  it "validates html files" do
    expect(validator.should_validate?("00000001.html")).to be true
  end

  it "validates xml files" do
    expect(validator.should_validate?("00000001.xml")).to be true
  end

  it "does not validate tif files" do
    expect(validator.should_validate?("00000001.tif")).to be false
  end

  it "does not validate jp2 files" do
    expect(validator.should_validate?("00000001.jp2")).to be false
  end
end
