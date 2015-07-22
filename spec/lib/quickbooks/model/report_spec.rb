describe Quickbooks::Model::Report do

  def build_report(fixture_name)
    xml = Nokogiri.parse(fixture(fixture_name))
    Quickbooks::Model::Report.new(xml: xml)
  end

  let(:report) { build_report("balancesheet.xml") }
  let(:report_with_years) { build_report("balance_sheet_with_year_summary.xml") }

  describe "#xml" do
    it 'exposes the full xml response' do
      report.xml.should be_a(Nokogiri::XML::Document)
    end

    it 'removes xml namespaces so xpath queries can be done made without specifying the namespace' do
      report.xml.xpath('//Column').length.should == 2
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
      report.all_rows.length.should == (report.xml.xpath('//Row').length + report.xml.xpath('//Summary').length)
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
  end

  describe "#find_row" do
  end
end
