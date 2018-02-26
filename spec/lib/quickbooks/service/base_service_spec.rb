describe Quickbooks::Service::BaseService do

  it ".is_json" do
    construct_service :invoice
    expect(@service.is_json?).to be_false
    construct_service :tax_service
    expect(@service.is_json?).to be_true
  end

  describe "#url_for_query" do
    shared_examples "encoding the query correctly" do |domain|
      let(:correct_url) { "https://#{domain}/v3/company/1234/query?query=SELECT+*+FROM+Customer+where+Name+%3D+%27John%27" }

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
      @service.oauth.is_a?(OAuth::AccessToken).should == true
    end
  end

  describe 'do_http' do
    let(:base_url) { 'http://example.com/'}

    [:get, :post, :upload].each do |request_method|
      context 'when no access_token exists' do
        before do
          construct_service :base_service, nil
        end

        it "should raise RunTimeError" do
          expect { @service.send(:do_http, request_method, base_url, nil, {}) }.to raise_error
        end
      end
    end

    context 'when an access token exists' do
      [:get, :post].each do |request_method|
        context "when the method is #{request_method}" do
          before do
            construct_service :base_service
            @service.stub(:do_http).and_call_original
          end

          context 'when a non-302 response is received' do
            before do
              stub_request(request_method, base_url, ["200", "OK"], fixture("items.xml"))
            end

            it "calls do_http only once" do
              @service.send(:do_http, request_method, base_url, nil, {})
              @service.should have_received(:do_http).once
            end
          end

          context 'when a 302 response is received' do
            let(:headers) do
              {
                "Content-Type" => "application/xml",
                "Accept" => "application/xml",
                "Accept-Encoding" => "gzip, deflate"
              }
            end
            let(:redirect_location) { "#{base_url}elsewhere" }

            before do
              stub_request(request_method, base_url, ["302", "Found"], fixture("items.xml"), :location => redirect_location)
              stub_request(request_method, redirect_location, ["200", "OK"], fixture("items.xml"))
            end

            it "calls do_http twice" do
              @service.send(:do_http, request_method, base_url, nil, headers)
              @service.should have_received(:do_http).with(request_method, base_url, nil, headers).once
              @service.should have_received(:do_http).with(request_method, redirect_location, nil, headers).once
            end
          end
        end
      end

      context 'when the method is upload' do
        before do
          construct_service :base_service
          @service.stub(:do_http).and_call_original
        end

        context 'when a non-302 response is received' do
          before do
            stub_request(:post, base_url, ["200", "OK"], fixture("items.xml"))
          end

          it "calls do_http only once" do
            @service.send(:do_http, :upload, base_url, nil, {})
            @service.should have_received(:do_http).once
          end
        end

        context 'when a 302 response is received' do
          let(:headers) do
            {
              "Content-Type" => "application/xml",
              "Accept" => "application/xml",
              "Accept-Encoding" => "gzip, deflate"
            }
          end
          let(:redirect_location) { "#{base_url}elsewhere" }

          before do
            stub_request(:post, base_url, ["302", "Found"], fixture("items.xml"), :location => redirect_location)
          end

          it "calls do_http only once" do
            begin
              @service.send(:do_http, :upload, base_url, nil, {})
            rescue
              @service.should have_received(:do_http).once
            end
          end

          it 'raises an error' do
            expect { @service.send(:do_http, :upload, base_url, nil, headers) }.to raise_error(Quickbooks::UnhandledHttpRedirect)
          end
        end
      end
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

    it "should raise ServiceUnavailable on HTTP 503 and 504" do
      xml = fixture('generic_error.xml')

      response = Struct.new(:code, :plain_body).new(503, xml)
      expect { @service.send(:check_response, response) }.to raise_error(Quickbooks::ServiceUnavailable)

      response = Struct.new(:code, :plain_body).new(504, xml)
      expect { @service.send(:check_response, response) }.to raise_error(Quickbooks::ServiceUnavailable)
    end

    it "handles error XML with a missing namespace" do
      xml = <<-XML
<?xml version=\"1.0\"?>
<IntuitResponse time="2013-11-15T13:16:49.528-08:00">
  <Fault type="SystemFault">
    <Error code="10000">
      <Message>An application error has occurred while processing your request</Message>
      <Detail>System Failure Error: Could not find resource for relative : some more info here</Detail>
    </Error>
  </Fault>
</IntuitResponse>
      XML
      response = Struct.new(:code, :plain_body).new(200, xml)

      begin
        @service.send :check_response, response
        fail "Exception expected"
      rescue Quickbooks::IntuitRequestException => exception
        expect(exception.detail).to eq(xml)
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
