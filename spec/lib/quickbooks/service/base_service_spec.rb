describe Quickbooks::Service::BaseService do

  it ".is_json" do
    construct_service :invoice
    expect(@service.is_json?).to be_false
    construct_service :tax_service
    expect(@service.is_json?).to be_true
  end

  describe "#url_for_query" do
    shared_examples "encoding the query correctly" do |domain|
      let(:correct_url) { "https://#{domain}/v3/company/1234/query?query=SELECT+%2A+FROM+Customer+where+Name+%3D+%27John%27" }

      it "correctly encodes the query" do
        subject.realm_id = 1234
        query = "SELECT * FROM Customer where Name = 'John'"
        subject.url_for_query(query).should include(correct_url)
      end
    end

    context "with the production API" do
      it_behaves_like "encoding the query correctly", Quickbooks::Service::BaseService::BASE_DOMAIN
    end

    context "with the sandbox API" do
      around do |example|
        Quickbooks.sandbox_mode = true
        example.run
        Quickbooks.sandbox_mode = false
      end
      it_behaves_like "encoding the query correctly", Quickbooks::Service::BaseService::SANDBOX_DOMAIN
    end

    it "raises an error if there is not realm id" do
      expect{subject.url_for_query("")}.to raise_error(Quickbooks::MissingRealmError)
    end
  end

  describe 'constructor' do
    before do
      construct_compact_service :base_service
    end

    it "correctly initializes with an access_token and realm" do
      @service.company_id.should == "9991111222"
      @service.oauth.should_not be_nil
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
        @service.send(:check_response, response, :request => xml2)
      rescue Quickbooks::IntuitRequestException => ex
        ex.request_xml.should == xml2
      end
    end

    it "should raise AuthorizationFailure on HTTP 401" do
      xml = fixture('generic_error.xml')

      response = Struct.new(:code, :plain_body).new(401, xml)
      expect { @service.send(:check_response, response) }.to raise_error(Quickbooks::AuthorizationFailure)
    end

    it "should raise Forbidden on HTTP 403" do
      xml = fixture('generic_error.xml')

      response = Struct.new(:code, :plain_body).new(403, xml)
      expect { @service.send(:check_response, response) }.to raise_error(Quickbooks::Forbidden)
    end

    it "should raise ThrottleExceeded on HTTP 403 with appropriate message" do
      xml = fixture('throttle_exceeded_error.xml')

      response = Struct.new(:code, :plain_body).new(403, xml)
      expect { @service.send(:check_response, response) }.to raise_error(Quickbooks::ThrottleExceeded)
    end

    it "should raise NotFound on HTTP 404" do
      html = <<-HTML
<!DOCTYPE HTML PUBLIC "-//IETF//DTD HTML 2.0//EN">
<html>
  <head>
    <title>404 Not Found</title>
  </head>
  <body>
    <h1>Not Found</h1>
    <p>The requested URL /v3/company/1413511890/query was not found on this server.</p>
  </body>
</html>
      HTML

      response = Struct.new(:code, :plain_body).new(404, html)
      expect { @service.send(:check_response, response) }.to raise_error(Quickbooks::NotFound)
    end

    it "should raise NotFound on HTTP 404" do
      html = <<-HTML
<!DOCTYPE HTML PUBLIC "-//IETF//DTD HTML 2.0//EN">
<html>
  <head>
    <title>413 Request Entity Too Large</title>
  </head>
  <body>
    <h1>Request Entity Too Large</h1>
    The requested resource<br />
    /v3/company/123145730715194/batch<br />
    does not allow request data with POST requests, or the amount of data provided in
    the request exceeds the capacity limit.
  </body>
</html>
      HTML

      response = Struct.new(:code, :plain_body).new(413, html)
      expect { @service.send(:check_response, response) }.to raise_error(Quickbooks::RequestTooLarge)
    end

    it "should raise TooManyRequests on HTTP 429 with appropriate message" do
      xml = fixture('too_many_requests_error.xml')
      message = Nokogiri::XML::Document.parse(xml) do |config|
        config.noblanks
      end.css('Message').text

      response = Struct.new(:code, :plain_body).new(429, xml)
      expect { @service.send(:check_response, response) }.to raise_error(Quickbooks::TooManyRequests, message)
    end

    it "should raise ServiceUnavailable on HTTP 502, 503 and 504" do
      xml = fixture('generic_error.xml')

      response = Struct.new(:code, :plain_body).new(502, xml)
      expect { @service.send(:check_response, response) }.to raise_error(Quickbooks::ServiceUnavailable)

      response = Struct.new(:code, :plain_body).new(503, xml)
      expect { @service.send(:check_response, response) }.to raise_error(Quickbooks::ServiceUnavailable)

      response = Struct.new(:code, :plain_body).new(504, xml)
      expect { @service.send(:check_response, response) }.to raise_error(Quickbooks::ServiceUnavailable)
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
      stub_http_request(:get, @service.url_for_query, ["200", "OK"], fixture("vendors.xml"))
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
