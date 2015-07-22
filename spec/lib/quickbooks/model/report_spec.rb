describe Quickbooks::Model::Report do

  def build_report(fixture_name)
    xml = Nokogiri.parse(fixture(fixture_name))
    Quickbooks::Model::Report.new(xml: xml)
  end

  before(:each) do
    @report = build_report("balancesheet.xml")
  end

  describe "#xml" do
    it 'exposes the full xml response' do
      @report.xml.should be_a(Nokogiri::XML::Document)
    end

    it 'removes xml namespaces so xpath queries can be done made without specifying the namespace' do
      @report.xml.xpath('//Column').length.should == 2
    end
  end

  describe "#columns" do
    it 'returns an array containing items for each <Column>' do
      @report.columns.should == ["", "TOTAL"]
    end
  end

  describe "#all_rows" do
    it 'returns a flat array containing all Row and Summary elements from the response xml' do
      @report.all_rows.length.should > 1
      @report.all_rows.length.should == (@report.xml.xpath('//Row').length + @report.xml.xpath('//Summary').length)
    end

    it 'returns a flat array containing all <Row> and <Summary> elements' do
      @report.all_rows[0].should == ['ASSETS', nil]
      @report.all_rows[1].should == ['Current Assets', nil]
      @report.all_rows[2].should == ['Bank Accounts', nil]
      @report.all_rows[3].should == ['Checking', BigDecimal.new("1201.00")]
      @report.all_rows[4].should == ['Savings', BigDecimal.new("800.00")]
    end
  end

  describe "#find_row" do
  end
end
