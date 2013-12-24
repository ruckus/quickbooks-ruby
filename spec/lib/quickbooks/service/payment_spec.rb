describe "Quickbooks::Service::Payment" do
  before(:all) do
    construct_service :payment
  end

  it "can query for payments" do
    xml = fixture("payments.xml")
    model = Quickbooks::Model::Payment

    stub_request(:get, @service.url_for_query, ["200", "OK"], xml)
    payments = @service.query
    payments.entries.count.should == 1

    first_payment = payments.entries.first
    first_payment.doc_number.should == '1001'
  end

  it "can fetch an Payment by ID" do
    xml = fixture("fetch_payment_by_id.xml")
    model = Quickbooks::Model::Payment
    stub_request(:get, "#{@service.url_for_resource(model::REST_RESOURCE)}/1", ["200", "OK"], xml)
    payment = @service.fetch_by_id(1)
    payment.doc_number.should == "1001"
  end

  it "cannot create an Payment without any line items" do
    payment = Quickbooks::Model::Payment.new

    lambda do
    @service.create(payment)
    end.should raise_error(InvalidModelException)

    payment.valid?.should == false
    payment.errors.keys.include?(:line_items).should == true
  end

  it "is valid when it has 1 or more line items" do
    payment = Quickbooks::Model::Payment.new
    payment.line_items << Quickbooks::Model::InvoiceLineItem.new

    lambda do
      @service.create(payment)
    end.should raise_error(InvalidModelException)

    payment.valid?.should == false
    payment.errors.keys.include?(:line_items).should_not == true
  end

  it "cannot create an Payment without a CustomerRef" do
    payment = Quickbooks::Model::Payment.new

    lambda do
      @service.create(payment)
    end.should raise_error(InvalidModelException)

    payment.valid?.should == false
    payment.errors.keys.include?(:customer_ref).should == true
  end

  it "is valid when a CustomerRef is specified" do
    payment = Quickbooks::Model::Payment.new
    payment.customer_id = 2

    lambda do
      @service.create(payment)
    end.should raise_error(InvalidModelException)

    payment.valid?.should == false
    payment.errors.keys.include?(:customer_ref).should_not == true
  end

  it "can create an Payment" do
    xml = fixture("fetch_payment_by_id.xml")
    model = Quickbooks::Model::Payment

    stub_request(:post, @service.url_for_resource(model::REST_RESOURCE), ["200", "OK"], xml)

    payment = Quickbooks::Model::Payment.new
    payment.customer_id = 2

    line_item = Quickbooks::Model::InvoiceLineItem.new
    line_item.amount = 50
    line_item.description = "Plush Baby Doll"
    line_item.sales_item! do |detail|
      detail.unit_price = 50
      detail.quantity = 1
      detail.item_ref = 1
      detail.tax_code_ref = 'NON'
    end

    payment.line_items << line_item

    created_payment = @service.create(payment)
    created_payment.id.should == 1
  end

  it "can sparse update an Payment" do
    model = Quickbooks::Model::Payment

    payment = Quickbooks::Model::Payment.new
    payment.doc_number = "ABC-123"
    payment.customer_id = 2

    line_item = Quickbooks::Model::InvoiceLineItem.new
    line_item.amount = 50
    line_item.description = "Plush Baby Doll"
    line_item.sales_item! do |detail|
      detail.unit_price = 50
      detail.quantity = 1
      detail.item_ref = 1
      detail.tax_code_ref = 'NON'
    end

    payment.line_items << line_item

    xml = fixture("fetch_payment_by_id.xml")
    stub_request(:post, @service.url_for_resource(model::REST_RESOURCE), ["200", "OK"], xml)

    update_response = @service.update(payment, :sparse => true)
    update_response.doc_number.should == '1001'
  end

  it "can delete an Payment" do
    model = Quickbooks::Model::Payment
    payment = Quickbooks::Model::Payment.new
    payment.doc_number = "1001"
    payment.sync_token = 2
    payment.id = 1

    xml = fixture("payment_delete_success_response.xml")
    stub_request(:post, "#{@service.url_for_resource(model::REST_RESOURCE)}?operation=delete", ["200", "OK"], xml)

    response = @service.delete(payment)
    response.should == true
  end

end