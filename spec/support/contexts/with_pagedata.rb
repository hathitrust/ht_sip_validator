# frozen_string_literal: true

require "spec_helper"

shared_context "with pagedata fixtures" do
  let(:mocked_sip) { HathiTrust::SIP::SIP.new("") }
  include_context "with metadata fixtures"

  def pagedata_with(pageinfo)
    {"pagedata" => pageinfo}
      .merge(valid_metadata)
  end

  let(:no_pagedata) { valid_metadata }

  let(:good_pagedata) do
    {"pagedata" =>
      {"00000001.jp2" => {"label" => "FRONT_COVER"},
       "00000007.jp2" => {"label" => "TITLE"},
       "00000008.tif" => {"label" => "COPYRIGHT"},
       "00000009.jp2" => {"orderlabel" => "i", "label" => "TABLE_OF_CONTENTS"},
       "00000010.jp2" => {"orderlabel" => "ii", "label" => "PREFACE"},
       "00000011.tif" => {"orderlabel" => "iii"}}}
      .merge(valid_metadata)
  end
end
