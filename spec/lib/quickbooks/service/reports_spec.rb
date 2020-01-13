describe "Quickbooks::Service::Report" do
  before(:all) do
    construct_service :reports
  end

  describe '.url_for_query()' do
    it 'uses "BalanceSheet" and "This Fiscal Year to date" as the default parameters' do
      expect(@service.url_for_query()).to eq('https://quickbooks.api.intuit.com/v3/company/9991111222/reports/BalanceSheet?date_macro=This+Fiscal+Year-to-date')
    end

    it 'allows overriding the report type' do
      expect(@service.url_for_query('ProfitAndLoss')).to eq('https://quickbooks.api.intuit.com/v3/company/9991111222/reports/ProfitAndLoss?date_macro=This+Fiscal+Year-to-date')
    end

    it 'allows overriding the date_macro' do
      expect(@service.url_for_query('BalanceSheet', 'Last Year')).to eq('https://quickbooks.api.intuit.com/v3/company/9991111222/reports/BalanceSheet?date_macro=Last+Year')
    end

    it 'allows passing additional query parameters' do
      url = @service.url_for_query('BalanceSheet', 'Last Year',
        :start_date => '2015-01-01',
        :end_date => '2015-01-31',
        :accounting_method => 'Cash',
        :columns => 'subt_nat_amount,tax_amount',
      )
      expect(url).to eq('https://quickbooks.api.intuit.com/v3/company/9991111222/reports/BalanceSheet?start_date=2015-01-01&end_date=2015-01-31&accounting_method=Cash&columns=subt_nat_amount,tax_amount')
    end

    it 'currently ignores the date_macro argument when passed in additional options' do
      expect(@service.url_for_query('BalanceSheet', 'Today', :accounting_method => 'Cash')).to eq('https://quickbooks.api.intuit.com/v3/company/9991111222/reports/BalanceSheet?accounting_method=Cash')
    end
  end

  it 'forwards arguments to .url_for_query' do
    xml = fixture("balancesheet.xml")
    url = @service.url_for_query('BalanceSheet', 'Today', :accounting_method => 'Cash')
    stub_http_request(:get, url, ["200", "OK"], xml)

    @service.query('BalanceSheet', 'Today', :accounting_method => 'Cash')
  end

  it "returns a Report model" do
    xml = fixture("balancesheet.xml")

    stub_http_request(:get, @service.url_for_query, ["200", "OK"], xml)
    report = @service.query('BalanceSheet')

    expect(report).to be_a Quickbooks::Model::Report
  end

end
