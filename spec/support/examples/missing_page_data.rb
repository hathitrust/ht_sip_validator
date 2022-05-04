# frozen_string_literal: true

# let(:validator) { SomeValidator.new }
shared_examples_for "a validator that can handle missing pagedata" do
  context "with missing pagedata" do
    include_context "with metadata fixtures"
    let(:mocked_sip) { HathiTrust::SIP::SIP.new("") }
    before(:each) do
      allow(mocked_sip).to receive(:metadata).and_return(valid_metadata)
      allow(mocked_sip).to receive(:files)
        .and_return(%w[meta.yml checksum.md5 00000001.tif])
    end

    it_behaves_like "a validator with a valid package"
  end
end
