describe "Quickbooks::Service::Invoice" do
  before(:all) do
    construct_service :invoice
  end

  it "can query for invoices" do
    xml = fixture("invoices.xml")
    model = Quickbooks::Model::Invoice

    stub_request(:get, @service.url_for_query, ["200", "OK"], xml)
    invoices = @service.query
    invoices.entries.count.should == 1

    first_invoice = invoices.entries.first
    first_invoice.doc_number.should == '1001'
  end

  it "can fetch an Invoice by ID" do
    xml = fixture("fetch_invoice_by_id.xml")
    model = Quickbooks::Model::Invoice
    stub_request(:get, "#{@service.url_for_resource(model::REST_RESOURCE)}/1", ["200", "OK"], xml)
    invoice = @service.fetch_by_id(1)
    invoice.doc_number.should == "1001"
  end

  it "cannot create an Invoice without any line items" do
    invoice = Quickbooks::Model::Invoice.new

    lambda do
      @service.create(invoice)
    end.should raise_error(Quickbooks::InvalidModelException, /At least 1 line item is required/)

    invoice.valid?.should == false
    invoice.errors.keys.include?(:line_items).should == true
  end

  it "is valid when it has 1 or more line items" do
    invoice = Quickbooks::Model::Invoice.new
    invoice.line_items << Quickbooks::Model::InvoiceLineItem.new

    lambda do
      @service.create(invoice)
    end.should raise_error(Quickbooks::InvalidModelException)

    invoice.valid?.should == false
    invoice.errors.keys.include?(:line_items).should_not == true
  end

  it "cannot create an Invoice without a CustomerRef" do
    invoice = Quickbooks::Model::Invoice.new

    lambda do
      @service.create(invoice)
    end.should raise_error(Quickbooks::InvalidModelException)

    invoice.valid?.should == false
    invoice.errors.keys.include?(:customer_ref).should == true
  end

  it "is valid when a CustomerRef is specified" do
    invoice = Quickbooks::Model::Invoice.new
    invoice.customer_id = 2

    lambda do
      @service.create(invoice)
    end.should raise_error(Quickbooks::InvalidModelException)

    invoice.valid?.should == false
    invoice.errors.keys.include?(:customer_ref).should_not == true
  end

  it "can create an Invoice" do
    xml = fixture("fetch_invoice_by_id.xml")
    model = Quickbooks::Model::Invoice

    stub_request(:post, @service.url_for_resource(model::REST_RESOURCE), ["200", "OK"], xml)

    invoice = Quickbooks::Model::Invoice.new
    invoice.customer_id = 2

    line_item = Quickbooks::Model::InvoiceLineItem.new
    line_item.amount = 50
    line_item.description = "Plush Baby Doll"
    line_item.sales_item! do |detail|
      detail.unit_price = 50
      detail.quantity = 1
      detail.item_id = 1
      detail.tax_code_id = 'NON'
    end

    invoice.line_items << line_item

    created_invoice = @service.create(invoice)
    created_invoice.id.should == 1
  end

  it "can sparse update an Invoice" do
    model = Quickbooks::Model::Invoice

    invoice = Quickbooks::Model::Invoice.new
    invoice.doc_number = "ABC-123"
    invoice.customer_id = 2

    line_item = Quickbooks::Model::InvoiceLineItem.new
    line_item.amount = 50
    line_item.description = "Plush Baby Doll"
    line_item.sales_item! do |detail|
      detail.unit_price = 50
      detail.quantity = 1
      detail.item_id = 1
      detail.tax_code_id = 'NON'
    end

    invoice.line_items << line_item

    xml = fixture("fetch_invoice_by_id.xml")
    stub_request(:post, @service.url_for_resource(model::REST_RESOURCE), ["200", "OK"], xml)

    update_response = @service.update(invoice, :sparse => true)
    update_response.doc_number.should == '1001'
  end

  it "can delete an Invoice" do
    model = Quickbooks::Model::Invoice
    invoice = Quickbooks::Model::Invoice.new
    invoice.doc_number = "1001"
    invoice.sync_token = 2
    invoice.id = 1

    xml = fixture("invoice_delete_success_response.xml")
    stub_request(:post, "#{@service.url_for_resource(model::REST_RESOURCE)}?operation=delete", ["200", "OK"], xml)

    response = @service.delete(invoice)
    response.should == true
  end

  it "can generate an invoice with a discount line item" do
    model = Quickbooks::Model::Invoice
    invoice = Quickbooks::Model::Invoice.new

    xml = fixture("invoice_with_discount_line_item_response.xml")
    stub_request(:post, @service.url_for_resource(model::REST_RESOURCE), ["200", "OK"], xml)

    invoice.customer_id = 3
    invoice.txn_date = Date.civil(2014, 3, 12)
    invoice.doc_number = "1001"
    sales_line_item = Quickbooks::Model::InvoiceLineItem.new
    sales_line_item.amount = 50
    sales_line_item.description = "Plush Baby Doll"
    sales_line_item.sales_item! do |detail|
      detail.unit_price = 50
      detail.quantity = 1
      detail.item_id = 2 # Item ID here
    end

    discount_line_item = Quickbooks::Model::InvoiceLineItem.new
    discount_line_item.amount = 5
    discount_line_item.discount_item! do |detail|
      detail.discount_percent = 10
      detail.percent_based = true
      detail.discount_account_id = 54
    end

    invoice.line_items << sales_line_item
    invoice.line_items << discount_line_item

    created_invoice = @service.create(invoice)
    created_invoice.id.should == 4
  end

end
