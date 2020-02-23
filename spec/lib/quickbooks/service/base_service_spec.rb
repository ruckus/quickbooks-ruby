describe Quickbooks::Service::BaseService do

  it ".is_json" do
    construct_service :invoice
    expect(@service.is_json?).to be false
    construct_service :tax_service
    expect(@service.is_json?).to be true
  end

  describe "#url_for_query" do
    shared_examples "encoding the query correctly" do |domain|
      let(:correct_url) { "https://#{domain}/v3/company/1234/query?query=SELECT+%2A+FROM+Customer+where+Name+%3D+%27John%27" }

      it "correctly encodes the query" do
        subject.realm_id = 1234
        query = "SELECT * FROM Customer where Name = 'John'"
        expect(subject.url_for_query(query)).to include(correct_url)
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
      expect(@service.company_id).to eq("9991111222")
      expect(@service.oauth).not_to be_nil
    end
  end

  describe 'check_response' do
    before do
      construct_service :base_service
    end

    it "should throw request exception with no options" do
      xml = fixture('generic_error.xml')
      response = Struct.new(:code, :plain_body).new(400, xml)
      expect { @service.send(:check_response, response) }.to raise_error(Quickbooks::IntuitRequestException)
    end

    it "should add request xml to request exception" do
      xml = fixture('generic_error.xml')
      xml2 = fixture('customer.xml')
      response = Struct.new(:code, :plain_body).new(400, xml)
      begin
        @service.send(:check_response, response, :request => xml2)
      rescue Quickbooks::IntuitRequestException => ex
        expect(ex.request_xml).to eq(xml2)
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
      expect(Quickbooks.logger).not_to receive(:info)
      @service.query
    end

    it "should log if Quickbooks.log = true" do
      Quickbooks.log = true
      obj = double('obj', :to_xml => '<test/>')
      expect_any_instance_of(Nokogiri::XML::Document).to receive(:to_xml) { |arg| obj.to_xml }
      expect(obj).to receive(:to_xml).once # will only called once on a get request, twice on a post
      expect(Quickbooks.logger).to receive(:info).at_least(1)
      @service.query
      Quickbooks.log = false
    end

    it "should log if Quickbooks.log = true but not prettyprint the xml" do
      Quickbooks.log = true
      Quickbooks.log_xml_pretty_print = false
      expect_any_instance_of(Nokogiri::XML::Document).not_to receive(:to_xml)
      expect(Quickbooks.logger).to receive(:info).at_least(1)
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

  describe "request hooks" do
    context "with before_request" do
      before do
        construct_service :vendor
        @service.before_request = proc do |request_info|
          puts("BEFORE REQUEST:")
          puts("url: #{request_info.url}")
          puts("headers: #{request_info.headers}")
          puts("body: #{request_info.body}")
          puts("method: #{request_info.method}")
        end
        stub_http_request(:get, @service.url_for_query, %w[200 OK], fixture("vendors.xml"))
      end

      it "calls before_request" do
        output_string = "BEFORE REQUEST:\nurl: https://quickbooks.api.intuit.com/v3/company/9991111222/query?query=SE"\
                        "LECT+%2A+FROM+Vendor+STARTPOSITION+1+MAXRESULTS+20\nheaders: {\"Content-Type\"=>\"applicatio"\
                        "n/xml\", \"Accept\"=>\"application/xml\", \"Accept-Encoding\"=>\"gzip, deflate\"}\nbody: {}"\
                        "\nmethod: get\n"

        expect { @service.query }.to output(output_string).to_stdout
      end
    end

    context "with after_request" do
      before do
        construct_service :vendor
        @service.after_request = proc do |request_info, response|
          puts("AFTER REQUEST:")
          puts("url: #{request_info.url}")
          puts("headers: #{request_info.headers}")
          puts("body: #{request_info.body}")
          puts("method: #{request_info.method}")
          puts("response: #{response}")
        end
        stub_http_request(:get, @service.url_for_query, %w[200 OK], fixture("vendors.xml"))
      end

      it "calls after_request" do
        output_string = "AFTER REQUEST:\nurl: https://quickbooks.api.intuit.com/v3/company/9991111222/query?query=SEL"\
                        "ECT+%2A+FROM+Vendor+STARTPOSITION+1+MAXRESULTS+20\nheaders: {\"Content-Type\"=>\"application"\
                        "/xml\", \"Accept\"=>\"application/xml\", \"Accept-Encoding\"=>\"gzip, deflate\", \"Authoriza"\
                        "tion\"=>\"Bearer token\"}\nbody: {}\nmethod: get\nresponse: <IntuitResponse xmlns=\"http://s"\
                        "chema.intuit.com/finance/v3\" time=\"2013-04-23T08:55:53.298-07:00\">\n<QueryResponse startP"\
                        "osition=\"1\" maxResults=\"2\">\n  <Vendor domain=\"QBO\" sparse=\"false\">\n    <Id>1128</I"\
                        "d>\n    <SyncToken>2</SyncToken>\n    <MetaData>\n      <CreateTime>2013-04-22T08:55:33-07:0"\
                        "0</CreateTime>\n      <LastUpdatedTime>2013-04-22T08:55:33-07:00</LastUpdatedTime>\n    </Me"\
                        "taData>\n    <Title>Mr.</Title>\n    <GivenName>Sparse-lhhp</GivenName>\n    <MiddleName>T.<"\
                        "/MiddleName>\n    <FamilyName>Vendorton</FamilyName>\n    <Suffix>III.</Suffix>\n    <Compan"\
                        "yName>Vendor Company</CompanyName>\n    <DisplayName>Vendor-gqqh</DisplayName>\n    <PrintOn"\
                        "CheckName>U Vendor Company on Check</PrintOnCheckName>\n    <Active>true</Active>\n    <Othe"\
                        "rContactInfo>\n      <Type>TelephoneNumber</Type>\n      <Telephone>\n        <FreeFormNumbe"\
                        "r>(214) 387-2007</FreeFormNumber>\n      </Telephone>\n    </OtherContactInfo>\n    <TaxIden"\
                        "tifier>12-3456789</TaxIdentifier>\n    <Balance>534.55</Balance>\n    <Vendor1099>false</Ven"\
                        "dor1099>\n  </Vendor>\n  <Vendor domain=\"QBO\" sparse=\"false\">\n    <Id>1129</Id>\n    <S"\
                        "yncToken>2</SyncToken>\n    <MetaData>\n      <CreateTime>2013-04-23T08:55:33-07:00</CreateT"\
                        "ime>\n      <LastUpdatedTime>2013-04-23T08:55:33-07:00</LastUpdatedTime>\n    </MetaData>\n "\
                        "   <Title>Ms.</Title>\n    <GivenName>Sparse-lhpW82tFa5</GivenName>\n    <MiddleName>U.</Mid"\
                        "dleName>\n    <FamilyName>Vendor</FamilyName>\n    <Suffix>II.</Suffix>\n    <CompanyName>Sp"\
                        "arse Vendor Company</CompanyName>\n    <DisplayName>Vendor-gqgcMz92ue</DisplayName>\n    <Pr"\
                        "intOnCheckName>U Vendor on Check</PrintOnCheckName>\n    <Active>true</Active>\n    <OtherCo"\
                        "ntactInfo>\n      <Type>TelephoneNumber</Type>\n      <Telephone>\n        <FreeFormNumber>("\
                        "214) 387-2008</FreeFormNumber>\n      </Telephone>\n    </OtherContactInfo>\n    <TaxIdentif"\
                        "ier>12-3456788</TaxIdentifier>\n    <Balance>0</Balance>\n    <Vendor1099>true</Vendor1099>"\
                        "\n  </Vendor>\n</QueryResponse>\n</IntuitResponse>\n"

        expect { @service.query }.to output(output_string).to_stdout
      end
    end

    context "with around_request" do
      before do
        construct_service :vendor
        @service.around_request = proc do |request_info, &block|
          puts("AROUND REQUEST (BEFORE CALL):")
          puts("url: #{request_info.url}")
          puts("headers: #{request_info.headers}")
          puts("body: #{request_info.body}")
          puts("method: #{request_info.method}")
          response = block.call # call block
          puts("AROUND REQUEST (AFTER CALL):")
          puts("response: #{response.body}")
          response # make sure to return response
        end
        stub_http_request(:get, @service.url_for_query, %w[200 OK], fixture("vendors.xml"))
      end

      it "calls around_request" do
        output_string = "AROUND REQUEST (BEFORE CALL):\nurl: https://quickbooks.api.intuit.com/v3/company/9991111222/"\
                        "query?query=SELECT+%2A+FROM+Vendor+STARTPOSITION+1+MAXRESULTS+20\nheaders: {\"Content-Type\""\
                        "=>\"application/xml\", \"Accept\"=>\"application/xml\", \"Accept-Encoding\"=>\"gzip, deflate"\
                        "\"}\nbody: {}\nmethod: get\nAROUND REQUEST (AFTER CALL):\nresponse: <IntuitResponse xmlns=\""\
                        "http://schema.intuit.com/finance/v3\" time=\"2013-04-23T08:55:53.298-07:00\">\n<QueryRespons"\
                        "e startPosition=\"1\" maxResults=\"2\">\n  <Vendor domain=\"QBO\" sparse=\"false\">\n    <Id"\
                        ">1128</Id>\n    <SyncToken>2</SyncToken>\n    <MetaData>\n      <CreateTime>2013-04-22T08:55"\
                        ":33-07:00</CreateTime>\n      <LastUpdatedTime>2013-04-22T08:55:33-07:00</LastUpdatedTime>\n"\
                        "    </MetaData>\n    <Title>Mr.</Title>\n    <GivenName>Sparse-lhhp</GivenName>\n    <Middle"\
                        "Name>T.</MiddleName>\n    <FamilyName>Vendorton</FamilyName>\n    <Suffix>III.</Suffix>\n   "\
                        " <CompanyName>Vendor Company</CompanyName>\n    <DisplayName>Vendor-gqqh</DisplayName>\n    "\
                        "<PrintOnCheckName>U Vendor Company on Check</PrintOnCheckName>\n    <Active>true</Active>\n "\
                        "   <OtherContactInfo>\n      <Type>TelephoneNumber</Type>\n      <Telephone>\n        <FreeF"\
                        "ormNumber>(214) 387-2007</FreeFormNumber>\n      </Telephone>\n    </OtherContactInfo>\n    "\
                        "<TaxIdentifier>12-3456789</TaxIdentifier>\n    <Balance>534.55</Balance>\n    <Vendor1099>fa"\
                        "lse</Vendor1099>\n  </Vendor>\n  <Vendor domain=\"QBO\" sparse=\"false\">\n    <Id>1129</Id>"\
                        "\n    <SyncToken>2</SyncToken>\n    <MetaData>\n      <CreateTime>2013-04-23T08:55:33-07:00<"\
                        "/CreateTime>\n      <LastUpdatedTime>2013-04-23T08:55:33-07:00</LastUpdatedTime>\n    </Meta"\
                        "Data>\n    <Title>Ms.</Title>\n    <GivenName>Sparse-lhpW82tFa5</GivenName>\n    <MiddleName"\
                        ">U.</MiddleName>\n    <FamilyName>Vendor</FamilyName>\n    <Suffix>II.</Suffix>\n    <Compan"\
                        "yName>Sparse Vendor Company</CompanyName>\n    <DisplayName>Vendor-gqgcMz92ue</DisplayName>"\
                        "\n    <PrintOnCheckName>U Vendor on Check</PrintOnCheckName>\n    <Active>true</Active>\n   "\
                        " <OtherContactInfo>\n      <Type>TelephoneNumber</Type>\n      <Telephone>\n        <FreeFor"\
                        "mNumber>(214) 387-2008</FreeFormNumber>\n      </Telephone>\n    </OtherContactInfo>\n    <T"\
                        "axIdentifier>12-3456788</TaxIdentifier>\n    <Balance>0</Balance>\n    <Vendor1099>true</Ven"\
                        "dor1099>\n  </Vendor>\n</QueryResponse>\n</IntuitResponse>\n"

        expect { @service.query }.to output(output_string).to_stdout
      end
    end
  end
end
