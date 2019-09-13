describe "Quickbooks::Service::Batch" do
  before(:all) do
    construct_service :batch
  end

  it "make batch request with success" do
    xml = fixture("batch_response.xml")
    stub_http_request(:post, @service.url_for_resource('batch'), ["200", "OK"], xml)
    batch_resp = @service.make_request(Quickbooks::Model::BatchRequest.new)
    batch_resp.class.should == Quickbooks::Model::BatchResponse
  end

  it "make batch request with error" do
    xml = fixture("batch_response.xml")
    Quickbooks.logger = $stdout
    stub_http_request(:post, @service.url_for_resource('batch'), ["400", ""], xml)
    Proc.new {
      @service.make_request(Quickbooks::Model::BatchRequest.new)
    }.should raise_error(Quickbooks::IntuitRequestException)
  end

  it "allows user to specify a RequestId in a create call" do
    requestid = "foobar123"
    xml = fixture("batch_response.xml")
    stub_http_request(:post, "#{@service.url_for_resource('batch')}?requestid=#{requestid}", ["200", "OK"], xml)
    batch_resp = @service.make_request(Quickbooks::Model::BatchRequest.new, :query => {:requestid => requestid})
    batch_resp.class.should == Quickbooks::Model::BatchResponse
  end
end
