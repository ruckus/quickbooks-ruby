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
      expect(report.xml).to be_a(Nokogiri::XML::Document)
      expect(report.xml.css('Column').length).to eq(2)
    end

    it 'preserves the xml namespace, which must be included in xpath queries' do
      expect(report.xml.xpath('/Report/Columns/Column').length).to eq(0)
      expect(report.xml.xpath("/xmlns:Report/xmlns:Columns/xmlns:Column").length).to eq(2)
    end
  end

  describe "#columns" do
    it 'returns an array containing items for each <Column>' do
      expect(report.columns).to eq(["", "TOTAL"])
      expect(report_with_years.columns).to eq(["", "Jul 4 - Dec 31, 2013", "Jan - Dec 2014", "Jan 1 - Jun 21, 2015"])
    end
  end

  describe "#all_rows" do
    it 'returns a flat array containing all Row and Summary elements from the response xml' do
      expect(report.all_rows.length).to be > 1
      expect(report.all_rows.length).to eq(report.xml.css('Row,Summary').length)
    end

    it 'returns a flat array containing all <Row> and <Summary> elements' do
      expect(report.all_rows[0]).to eq(['ASSETS', nil])
      expect(report.all_rows[1]).to eq(['Current Assets', nil])
      expect(report.all_rows[2]).to eq(['Bank Accounts', nil])
      expect(report.all_rows[3]).to eq(['Checking', BigDecimal("1201.00")])
      expect(report.all_rows[4]).to eq(['Savings', BigDecimal("800.00")])
    end

    it 'works with multiple columns' do
      expect(report_with_years.all_rows[3]).to eq(['Checking', nil, nil, BigDecimal("1201.00")])
      expect(report_with_years.all_rows[4]).to eq(['Savings', BigDecimal("19.99"), BigDecimal("19.99"), BigDecimal("819.99")])
    end

    it 'works with text columns' do
      expect(age_payable_report.all_rows[0]).to eq(['Text replacment', nil, nil, nil, nil, nil, nil, nil])
      expect(age_payable_report.all_rows[1]).to eq(['2018-05-18', 'Journal Entry', BigDecimal('1'), 'Robot', '2012-04-18', BigDecimal('99999'), BigDecimal('-12345678.00'), BigDecimal('-12345678.00')])
      expect(age_payable_report.all_rows[2]).to eq(['2018-05-18', 'Bill', nil, 'Robot Parts', '2016-05-28', BigDecimal('100'), BigDecimal('100'), BigDecimal('100')])
      expect(age_payable_report.all_rows[3]).to eq(['Total', nil, nil, nil, nil, nil, BigDecimal('.00'), BigDecimal('.00')])
      expect(age_payable_report.all_rows[4]).to eq(['TOTAL', nil, nil, nil, nil, nil, BigDecimal('.00'), BigDecimal('.00')])
    end
  end

  describe "#find_row" do
    it "returns the given row if the label matches" do
      expect(report.find_row('Checking')).to eq(['Checking', BigDecimal("1201.00")])
      expect(report.find_row('Opening Balance Equity')).to eq(['Opening Balance Equity', BigDecimal("-9337.50")])
    end

    it "returns nil if the label was not found" do
      expect(report.find_row('Shoes for the dog!')).to eq(nil)
    end
  end
end
