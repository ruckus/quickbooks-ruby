describe "Quickbooks::Model::SalesItemLineDetail" do

  it "rate percent should be a decimal/float if set" do
    detail = Quickbooks::Model::SalesItemLineDetail.new
    detail.rate_percent = 10
    expect(detail.to_xml.at_css('RatePercent').content).to eq('10.0')
  end

  it "rate percent should not be included if not set" do
    detail = Quickbooks::Model::SalesItemLineDetail.new
    expect(detail.to_xml).not_to match(/RatePercent/)
  end
end
