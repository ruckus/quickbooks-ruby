describe "Quickbooks::Service::Invoice" do
  before(:all) do
    construct_service :invoice
  end

  it "can query for invoices" do
    xml = fixture("invoices.xml")
    model = Quickbooks::Model::Invoice

    stub_http_request(:get, @service.url_for_query, ["200", "OK"], xml)
    invoices = @service.query
    expect(invoices.entries.count).to eq 1

    first_invoice = invoices.entries.first
    expect(first_invoice.doc_number).to eq '1001'
  end

  it "can fetch an Invoice by ID" do
    xml = fixture("fetch_invoice_by_id.xml")
    model = Quickbooks::Model::Invoice
    stub_http_request(:get, %r{#{@service.url_for_resource(model::REST_RESOURCE)}/1}, ["200", "OK"], xml)
    invoice = @service.fetch_by_id(1)
    expect(invoice.doc_number).to eq "1001"
  end

  it "cannot create an Invoice without any line items" do
    invoice = Quickbooks::Model::Invoice.new

    expect {
      @service.create(invoice)
    }.to raise_error(Quickbooks::InvalidModelException, /At least 1 line item is required/)

    expect(invoice.valid?).to eq false
    expect(invoice.errors.keys.include?(:line_items)).to be true
  end

  it "is valid when it has 1 or more line items" do
    invoice = Quickbooks::Model::Invoice.new
    invoice.line_items << Quickbooks::Model::InvoiceLineItem.new

    expect {
      @service.create(invoice)
    }.to raise_error(Quickbooks::InvalidModelException)

    expect(invoice.valid?).to eq false
    expect(invoice.errors.keys.include?(:line_items)).to_not be true
  end

  it "cannot create an Invoice without a CustomerRef" do
    invoice = Quickbooks::Model::Invoice.new

    expect {
      @service.create(invoice)
    }.to raise_error(Quickbooks::InvalidModelException)

    expect(invoice.valid?).to eq false
    expect(invoice.errors.keys.include?(:customer_ref)).to be true
  end

  it "is valid when a CustomerRef is specified" do
    invoice = Quickbooks::Model::Invoice.new
    invoice.customer_id = 2

    expect {
      @service.create(invoice)
    }.to raise_error(Quickbooks::InvalidModelException)

    expect(invoice.valid?).to eq false
    expect(invoice.errors.keys.include?(:customer_ref)).to_not be true
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
    expect(created_invoice.id).to eq "1"
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
    expect(update_response.doc_number).to eq '1001'
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
    expect(response).to be true
  end

  it "can void an Invoice" do
    model = Quickbooks::Model::Invoice
    invoice = Quickbooks::Model::Invoice.new
    invoice.sync_token = 2
    invoice.id = 1

    xml = fixture("invoice_void_success_response.xml")
    stub_http_request(:post, "#{@service.url_for_resource(model::REST_RESOURCE)}?operation=void", ["200", "OK"], xml)

    response = @service.void(invoice)
    expect(response.private_note).to eq 'Voided'
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
    expect(created_invoice.id).to eq "4"
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
    expect(sent_invoice.email_status).to eq "EmailSent"
    expect(sent_invoice.delivery_info.delivery_type).to eq "Email"
    expect(sent_invoice.delivery_info.delivery_time).to eq(Time.new(2015, 2, 24, 18, 26, 03, "-08:00"))
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
    expect(sent_invoice.bill_email.address).to eq "test@intuit.com"
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
    expect(created_invoice.id).to eq "4"
  end

  it "can read line items from a bundle" do
    xml = fixture("invoice_with_bundle_line_item.xml")
    stub_http_request(:get, %r{#{@service.url_for_resource(Quickbooks::Model::Invoice::REST_RESOURCE)}/186}, ["200", "OK"], xml)
    invoice = @service.fetch_by_id(186)
    expect(invoice.valid?).to be true

    expect(invoice.doc_number).to eq "1020"

    expect(invoice.line_items.size).to eq 3
    bundles = invoice.line_items.select { |line| line.group_line_detail? }
    expect(bundles).to_not be nil
    bundle = bundles.first

    expect(bundle.description).to eq 'chocolate covered cookies and other sweets'
    expect(bundle.amount).to eq 0
    expect(bundle.group_line_detail.group_item_ref.name).to eq 'Assorted sweets'
    expect(bundle.group_line_detail.group_item_ref.value).to eq '24'
    expect(bundle.group_line_detail.quantity.to_i).to eq 3

    expect(bundle.group_line_detail.line_items.size).to eq 2

    bundle_line = bundle.group_line_detail.line_items[0]
    expect(bundle_line.sales_item?).to be true
    expect(bundle_line.id).to eq '2'
    expect(bundle_line.amount).to eq 7.96
    expect(bundle_line.sales_line_item_detail.item_ref["name"]).to eq "Chocolate Covered Strawberries"
    expect(bundle_line.sales_line_item_detail.quantity).to eq 15
    expect(bundle_line.sales_line_item_detail.unit_price).to eq 0.5306667
    expect(bundle_line.sales_line_item_detail.tax_code_ref.value).to eq '5'

    bundle_line = bundle.group_line_detail.line_items[1]
    expect(bundle_line.sales_item?).to be true
    expect(bundle_line.id).to eq '3'
    expect(bundle_line.amount).to eq 2.65
    expect(bundle_line.sales_line_item_detail.item_ref["name"]).to eq "Snow Cookie"
    expect(bundle_line.sales_line_item_detail.quantity).to eq 24
    expect(bundle_line.sales_line_item_detail.unit_price).to eq 0.1104167
    expect(bundle_line.sales_line_item_detail.tax_code_ref.value).to eq '5'

    bundle_total = bundle.group_line_detail.line_items.inject(0) { |acc, l| acc + (l.sales_line_item_detail.quantity * l.sales_line_item_detail.unit_price) }
    expect(bundle_total.round(2)).to eq 10.61
  end

  it "can sparse update an Invoice containing a bundle" do
    xml = fixture("invoice_with_bundle_line_item.xml")
    stub_http_request(:get, %r{#{@service.url_for_resource(Quickbooks::Model::Invoice::REST_RESOURCE)}/186}, ["200", "OK"], xml)
    invoice = @service.fetch_by_id(186)

    invoice.line_items.each do |l|
      if l.group_line_detail?
        l.description << " - updated"
        expect(l.description).to eq 'chocolate covered cookies and other sweets - updated'
        l.group_line_detail.line_items.each do |group_line_item|
          if group_line_item.sales_item?
            group_line_item.description << " - updated"
          end
        end
      end
    end

    stub_http_request(:post, @service.url_for_resource(Quickbooks::Model::Invoice::REST_RESOURCE), ["200", "OK"], xml)
    update_response = @service.update(invoice, :sparse => true)
    expect(update_response.doc_number).to eq '1020'
  end
end
