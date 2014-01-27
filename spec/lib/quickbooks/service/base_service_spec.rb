describe Quickbooks::Service::BaseService do
  describe "#url_for_query" do
    it "correctly encodes the query" do
      subject.realm_id = 1234
      query = "SELECT * FROM Customer where Name = 'John'"

      correct_url = "https://qb.sbfinance.intuit.com/v3/company/1234/query?query=SELECT+*+FROM+Customer+where+Name+%3D+%27John%27"
      subject.url_for_query(query).should include(correct_url)
    end
  end

  it "Correctly handled an IntuitRequestException" do
    construct_service :base_service
    xml = fixture("customer_duplicate_error.xml")
    response = Struct.new(:plain_body, :code).new(xml, 400)
    expect{ @service.send(:check_response, response) }.to raise_error(Quickbooks::IntuitRequestException, /is already using this name/)
  end
end
