describe Quickbooks::Model::Report do

  def build_report(fixture_name)
    xml = Nokogiri.parse(fixture(fixture_name))
    Quickbooks::Model::Report.new(xml: xml)
  end

  let(:report) { build_report("balancesheet.xml") }
  let(:report_with_years) { build_report("balance_sheet_with_year_summary.xml") }
  let(:age_payable_report) { build_report("age_payable_detail.xml") }

  describe "#xml" do
    it 'exposes the full xml response' do
      report.xml.should be_a(Nokogiri::XML::Document)
      report.xml.css('Column').length.should == 2
    end

    it 'preserves the xml namespace, which must be included in xpath queries' do
      report.xml.xpath('/Report/Columns/Column').length.should == 0
      report.xml.xpath("/xmlns:Report/xmlns:Columns/xmlns:Column").length.should == 2
    end
  end

  describe "#columns" do
    it 'returns an array containing items for each <Column>' do
      report.columns.should == ["", "TOTAL"]
      report_with_years.columns.should == ["", "Jul 4 - Dec 31, 2013", "Jan - Dec 2014", "Jan 1 - Jun 21, 2015"]
    end
  end

  describe "#all_rows" do
    it 'returns a flat array containing all Row and Summary elements from the response xml' do
      report.all_rows.length.should > 1
      report.all_rows.length.should == report.xml.css('Row,Summary').length
    end

    it 'returns a flat array containing all <Row> and <Summary> elements' do
      report.all_rows[0].should == ['ASSETS', nil]
      report.all_rows[1].should == ['Current Assets', nil]
      report.all_rows[2].should == ['Bank Accounts', nil]
      report.all_rows[3].should == ['Checking', BigDecimal("1201.00")]
      report.all_rows[4].should == ['Savings', BigDecimal("800.00")]
    end

    it 'works with multiple columns' do
      report_with_years.all_rows[3].should == ['Checking', nil, nil, BigDecimal("1201.00")]
      report_with_years.all_rows[4].should == ['Savings', BigDecimal("19.99"), BigDecimal("19.99"), BigDecimal("819.99")]
    end

    it 'works with text columns' do
      age_payable_report.all_rows[0].should == ['Text replacment', nil, nil, nil, nil, nil, nil, nil]
      age_payable_report.all_rows[1].should == ['2018-05-18', 'Journal Entry', BigDecimal('1'), 'Robot', '2012-04-18', BigDecimal('99999'), BigDecimal('-12345678.00'), BigDecimal('-12345678.00')]
      age_payable_report.all_rows[2].should == ['2018-05-18', 'Bill', nil, 'Robot Parts', '2016-05-28', BigDecimal('100'), BigDecimal('100'), BigDecimal('100')]
      age_payable_report.all_rows[3].should == ['Total', nil, nil, nil, nil, nil, BigDecimal('.00'), BigDecimal('.00')]
      age_payable_report.all_rows[4].should == ['TOTAL', nil, nil, nil, nil, nil, BigDecimal('.00'), BigDecimal('.00')]
    end
  end

  describe "#find_row" do
    it "returns the given row if the label matches" do
      report.find_row('Checking').should == ['Checking', BigDecimal("1201.00")]
      report.find_row('Opening Balance Equity').should == ['Opening Balance Equity', BigDecimal("-9337.50")]
    end

    it "returns nil if the label was not found" do
      report.find_row('Shoes for the dog!').should == nil
    end
  end
end
