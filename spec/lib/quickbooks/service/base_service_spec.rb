describe Quickbooks::Service::BaseService do

  describe "#url_for_query" do
    it "correctly encodes the query" do
      subject.realm_id = 1234
      query = "SELECT * FROM Customer where Name = 'John'"

      correct_url = "https://qb.sbfinance.intuit.com/v3/company/1234/query?query=SELECT+*+FROM+Customer+where+Name+%3D+%27John%27"
      subject.url_for_query(query).should include(correct_url)
    end
  end

  describe 'check_response' do
    before do
      construct_service :base_service
    end

    it "should throw request exception with no options" do
      xml = fixture('generic_error.xml')
      response = Struct.new(:code, :plain_body).new(400, xml)
      expect { @service.send(:check_response, response) }.to raise_error
    end

    it "should add request xml to request exception" do
      xml = fixture('generic_error.xml')
      xml2 = fixture('customer.xml')
      response = Struct.new(:code, :plain_body).new(400, xml)
      begin
        @service.send(:check_response, response, :request_xml => xml2)
      rescue Quickbooks::IntuitRequestException => ex
        ex.request_xml.should == xml2
      end
    end
  end

  it "Correctly handled an IntuitRequestException" do
    construct_service :base_service
    xml = fixture("customer_duplicate_error.xml")
    response = Struct.new(:plain_body, :code).new(xml, 400)
    expect{ @service.send(:check_response, response) }.to raise_error(Quickbooks::IntuitRequestException, /is already using this name/)
  end

  context 'logging' do
    let(:assortment) { [nil, 1, Object.new, [], {foo: 'bar'}] }

    before do
      construct_service :vendor
      stub_request(:get, @service.url_for_query, ["200", "OK"], fixture("vendors.xml"))
    end

    it "should not log by default" do
      Quickbooks.logger.should_receive(:info).never
      @service.query
    end

    it "should log if Quickbooks.log = true" do
      Quickbooks.log = true
      obj = double('obj', :to_xml => '<test/>')
      Nokogiri::XML::Document.any_instance.stub(:to_xml) { |arg| obj.to_xml }
      obj.should_receive(:to_xml).once # will only called once on a get request, twice on a post
      Quickbooks.logger.should_receive(:info).at_least(1)
      @service.query
      Quickbooks.log = false
    end

    it "should log if Quickbooks.log = true but not prettyprint the xml" do
      Quickbooks.log = true
      Quickbooks.log_xml_pretty_print = false
      Nokogiri::XML::Document.any_instance.should_not_receive(:to_xml)
      Quickbooks.logger.should_receive(:info).at_least(1)
      @service.query
      Quickbooks.log = false
      Quickbooks.log_xml_pretty_print = true
    end

    it "log_xml should handle a non-xml string" do
      assortment.each do |e|
        expect{ Quickbooks::Service::BaseService.new.log_xml(e) }.to_not raise_error
      end
    end

    it "log_xml should handle a non-xml string with pretty printing turned off" do
      Quickbooks.log_xml_pretty_print = false
      assortment.each do |e|
        expect{ Quickbooks::Service::BaseService.new.log_xml(e) }.to_not raise_error
      end
      Quickbooks.log_xml_pretty_print = true
    end
  end

end
