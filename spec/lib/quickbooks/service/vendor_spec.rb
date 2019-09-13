describe "Quickbooks::Service::Vendor" do
  before(:all) do
    construct_service :vendor
  end

  it "can query for vendors" do
    xml = fixture("vendors.xml")
    model = Quickbooks::Model::Vendor
    stub_http_request(:get, @service.url_for_query, ["200", "OK"], xml)
    vendors = @service.query
    vendors.entries.count.should == 2
    vendor1 = vendors.entries.first
    vendor1.company_name.should == 'Vendor Company'
    vendor2 = vendors.entries.last
    vendor2.company_name.should == 'Sparse Vendor Company'
  end

  it "can fetch a vendor by ID" do
    xml = fixture("fetch_vendor_by_id.xml")
    model = Quickbooks::Model::Vendor
    stub_http_request(:get, "#{@service.url_for_resource(model::REST_RESOURCE)}/1129", ["200", "OK"], xml)
    vendor = @service.fetch_by_id(1129)
    vendor.company_name.should == 'John Vendor Company'
  end

  it "cannot create a vendor with an invalid display_name" do
    vendor = Quickbooks::Model::Vendor.new
    vendor.display_name = 'Tractor:Trailer' # invalid because the name contains a colon
    vendor.valid?.should == false
    vendor.valid_for_create?.should == false
    expect{ @service.create(vendor) }.to raise_error(Quickbooks::InvalidModelException, /cannot contain a colon/)
    vendor.errors.keys.include?(:display_name).should == true
  end

  it "cannot create a vendor with an invalid email" do
    vendor = Quickbooks::Model::Vendor.new
    vendor.email_address = "foobar.com"
    vendor.valid_for_create?.should == false
    vendor.valid?.should == false
    expect{ @service.create(vendor) }.to raise_error(Quickbooks::InvalidModelException, /Email address must contain/)
    vendor.errors.keys.include?(:primary_email_address).should == true
  end

  it "can create a vendor" do
    xml = fixture("fetch_vendor_by_id.xml")
    model = Quickbooks::Model::Vendor
    stub_http_request(:post, @service.url_for_resource(model::REST_RESOURCE), ["200", "OK"], xml)
    vendor = Quickbooks::Model::Vendor.new
    vendor.company_name = "New Vendor Co"
    vendor.email_address = "info@newvendorco.com"
    billing_address = Quickbooks::Model::PhysicalAddress.new
    billing_address.line1 = "2001 Broad Str"
    billing_address.city = "Keene"
    billing_address.country_sub_division_code = "NH"
    billing_address.postal_code = "03455"
    billing_address.country = "United States"
    vendor.billing_address = billing_address
    vendor.valid_for_create?.should == true
    created_vendor = @service.create(vendor)
    created_vendor.id.should == "1129"
  end

  it "cannot sparse update a vendor" do
    model = Quickbooks::Model::Vendor
    vendor = Quickbooks::Model::Vendor.new
    vendor.display_name = "Vendor Corporation"
    vendor.sync_token = 2
    vendor.id = 1
    xml = fixture("fetch_vendor_by_id.xml")
    vendor.valid_for_update?.should == true
    expect{ @service.update(vendor, :sparse => true) }.to raise_error(Quickbooks::InvalidModelException, /Vendor sparse update is not supported/)
  end

  it "can delete a vendor" do
    model = Quickbooks::Model::Vendor
    vendor = Quickbooks::Model::Vendor.new
    vendor.display_name = 'Vendor Corporation'
    vendor.sync_token = 4
    vendor.id = 1129
    xml = fixture("deleted_vendor.xml")
    stub_http_request(:post, @service.url_for_resource(model::REST_RESOURCE), ["200", "OK"], xml, {}, true)
    vendor.valid_for_deletion?.should == true
    response = @service.delete(vendor)
    response.display_name.should == "#{vendor.display_name} (Deleted)"
    response.active?.should == false
  end

end
