describe "Quickbooks::Service::Invoice" do
  before(:all) do
    construct_service :invoice
  end

  it "can query for invoices" do
    xml = fixture("invoices.xml")
    model = Quickbooks::Model::Invoice

    stub_http_request(:get, @service.url_for_query, ["200", "OK"], xml)
    invoices = @service.query
    invoices.entries.count.should == 1

    first_invoice = invoices.entries.first
    first_invoice.doc_number.should == '1001'
  end

  it "can fetch an Invoice by ID" do
    xml = fixture("fetch_invoice_by_id.xml")
    model = Quickbooks::Model::Invoice
    stub_http_request(:get, %r{#{@service.url_for_resource(model::REST_RESOURCE)}/1}, ["200", "OK"], xml)
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

    stub_http_request(:post, @service.url_for_resource(model::REST_RESOURCE), ["200", "OK"], xml)

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
    created_invoice.id.should == "1"
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
    stub_http_request(:post, @service.url_for_resource(model::REST_RESOURCE), ["200", "OK"], xml)

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
    stub_http_request(:post, "#{@service.url_for_resource(model::REST_RESOURCE)}?operation=delete", ["200", "OK"], xml)

    response = @service.delete(invoice)
    response.should == true
  end

  it "can void an Invoice" do
    model = Quickbooks::Model::Invoice
    invoice = Quickbooks::Model::Invoice.new
    invoice.sync_token = 2
    invoice.id = 1

    xml = fixture("invoice_void_success_response.xml")
    stub_http_request(:post, "#{@service.url_for_resource(model::REST_RESOURCE)}?operation=void", ["200", "OK"], xml)

    response = @service.void(invoice)
    response.private_note.should == 'Voided'
  end

  it "can generate an invoice with a discount line item" do
    model = Quickbooks::Model::Invoice
    invoice = Quickbooks::Model::Invoice.new

    xml = fixture("invoice_with_discount_line_item_response.xml")
    stub_http_request(:post, @service.url_for_resource(model::REST_RESOURCE), ["200", "OK"], xml)

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
    created_invoice.id.should == "4"
  end

  it "can send an invoice using bill_email" do
    xml = fixture("invoice_send.xml")
    model = Quickbooks::Model::Invoice
    stub_http_request(:post, "#{@service.url_for_resource(model::REST_RESOURCE)}/1/send", ["200", "OK"], xml)

    invoice = Quickbooks::Model::Invoice.new
    invoice.doc_number = "1001"
    invoice.sync_token = 2
    invoice.id = 1
    sent_invoice = @service.send(invoice)
    sent_invoice.email_status.should == "EmailSent"
    sent_invoice.delivery_info.delivery_type.should == "Email"
    sent_invoice.delivery_info.delivery_time.should eq(Time.new(2015, 2, 24, 18, 26, 03, "-08:00"))
  end

  it "can send an invoice with new email_address" do
    xml = fixture("invoice_send.xml")
    model = Quickbooks::Model::Invoice
    stub_http_request(:post, "#{@service.url_for_resource(model::REST_RESOURCE)}/1/send?sendTo=test@intuit.com", ["200", "OK"], xml)

    invoice = Quickbooks::Model::Invoice.new
    invoice.doc_number = "1001"
    invoice.sync_token = 2
    invoice.id = 1
    sent_invoice = @service.send(invoice, "test@intuit.com")
    sent_invoice.bill_email.address.should == "test@intuit.com"
  end

  it "allows user to specify a RequestId in a create call" do
    requestid = "foobar123"
    model = Quickbooks::Model::Invoice
    invoice = Quickbooks::Model::Invoice.new

    xml = fixture("invoice_with_discount_line_item_response.xml")
    url = "#{@service.url_for_resource(model::REST_RESOURCE)}?requestid=#{requestid}"
    stub_http_request(:post, url, ["200", "OK"], xml)

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

    created_invoice = @service.create(invoice, :query => {:requestid => requestid})
    created_invoice.id.should == "4"
  end

  it "can read line items from a bundle" do
    xml = fixture("invoice_with_bundle_line_item.xml")
    stub_http_request(:get, %r{#{@service.url_for_resource(Quickbooks::Model::Invoice::REST_RESOURCE)}/186}, ["200", "OK"], xml)
    invoice = @service.fetch_by_id(186)
    invoice.valid?.should == true

    invoice.doc_number.should == "1020"

    invoice.line_items.size.should == 3
    bundles = invoice.line_items.select { |line| line.group_line_detail? }
    bundles.should_not == nil
    bundle = bundles.first

    bundle.description.should == 'chocolate covered cookies and other sweets'
    bundle.amount.should == 0
    bundle.group_line_detail.group_item_ref.name.should == 'Assorted sweets'
    bundle.group_line_detail.group_item_ref.value.should == '24'
    bundle.group_line_detail.quantity.to_i.should == 3

    bundle.group_line_detail.line_items.size.should == 2

    bundle_line = bundle.group_line_detail.line_items[0]
    bundle_line.sales_item?.should == true
    bundle_line.id.should == '2'
    bundle_line.amount.should == 7.96
    bundle_line.sales_line_item_detail.item_ref["name"].should == "Chocolate Covered Strawberries"
    bundle_line.sales_line_item_detail.quantity.should == 15
    bundle_line.sales_line_item_detail.unit_price.should == 0.5306667
    bundle_line.sales_line_item_detail.tax_code_ref.value.should == '5'

    bundle_line = bundle.group_line_detail.line_items[1]
    bundle_line.sales_item?.should == true
    bundle_line.id.should == '3'
    bundle_line.amount.should == 2.65
    bundle_line.sales_line_item_detail.item_ref["name"].should == "Snow Cookie"
    bundle_line.sales_line_item_detail.quantity.should == 24
    bundle_line.sales_line_item_detail.unit_price.should == 0.1104167
    bundle_line.sales_line_item_detail.tax_code_ref.value.should == '5'

    bundle_total = bundle.group_line_detail.line_items.inject(0) { |acc, l| acc + (l.sales_line_item_detail.quantity * l.sales_line_item_detail.unit_price) }
    bundle_total.round(2).should == 10.61
  end

  it "can sparse update an Invoice containing a bundle" do
    xml = fixture("invoice_with_bundle_line_item.xml")
    stub_http_request(:get, %r{#{@service.url_for_resource(Quickbooks::Model::Invoice::REST_RESOURCE)}/186}, ["200", "OK"], xml)
    invoice = @service.fetch_by_id(186)

    invoice.line_items.each do |l|
      if l.group_line_detail?
        l.description << " - updated"
        l.description.should == 'chocolate covered cookies and other sweets - updated'
        l.group_line_detail.line_items.each do |group_line_item|
          if group_line_item.sales_item?
            group_line_item.description << " - updated"
          end
        end
      end
    end

    stub_http_request(:post, @service.url_for_resource(Quickbooks::Model::Invoice::REST_RESOURCE), ["200", "OK"], xml)
    update_response = @service.update(invoice, :sparse => true)
    update_response.doc_number.should == '1020'
  end
end
