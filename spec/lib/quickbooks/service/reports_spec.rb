describe "Quickbooks::Service::Reports" do
  before(:all) do
    construct_service :reports
  end

  it "can query for Balance Sheets", focus: true do
    xml = fixture("balancesheet.xml")
    model = Quickbooks::Model::Reports

    stub_request(:get, @service.url_for_query, ["200", "OK"], xml)
    reports = @service.query('BalanceSheet')

    balance_sheet_xml = @service.last_response_xml
    balance_sheet_xml.xpath('//xmlns:ReportName').children.to_s == 'BalanceSheet'
  end

  it 'can query Balance Sheets between different dates' do 
    xml = fixture("balancesheet.xml")
    model = Quickbooks::Model::Reports

    stub_request(:get, @service.url_for_query('BalanceSheet', 'This Fiscal Quarter This Fiscal Quarter-to-date' ), ["200", "OK"], xml)
    reports = @service.query('BalanceSheet', 'This Fiscal Quarter This Fiscal Quarter-to-date' )

    balance_sheet_xml = @service.last_response_xml
    balance_sheet_xml.xpath('//xmlns:ReportName').children.to_s == 'BalanceSheet'
  end

  it 'can query Cash Flow' do 
    xml = fixture("cashflow.xml")
    model = Quickbooks::Model::Reports

    stub_request(:get, @service.url_for_query('CashFlow'), ["200", "OK"], xml)

    reports = @service.query('CashFlow')

    cash_flow_xml = @service.last_response_xml
    cash_flow_xml.xpath('//xmlns:ReportName').children.to_s == 'CashFlow'
  end

  it 'can query Profit and Loss' do 
    xml = fixture("profitloss.xml")
    model = Quickbooks::Model::Reports

    stub_request(:get, @service.url_for_query('ProfitAndLoss'), ["200", "OK"], xml)

    reports = @service.query('ProfitAndLoss')

    profit_loss_xml = @service.last_response_xml
    profit_loss_xml.xpath('//xmlns:ReportName').children.to_s == 'ProfitAndLoss'
  end
end