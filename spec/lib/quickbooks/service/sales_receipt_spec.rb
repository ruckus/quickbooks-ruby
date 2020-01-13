require 'spec_helper'

module Quickbooks
  module Service
    describe SalesReceipt do
      let(:line) do
        line = Model::Line.new
        line.amount = 10
        line.description = "Games"
        line.sales_item! do |sales_item|
          sales_item.item_id = 1
          sales_item.unit_price = 10
          sales_item.quantity = 1
        end

        line
      end

      let(:second_line) do
        line = Model::Line.new
        line.group_line! do |group_line|
          group_line.quantity = 15
          group_line.line_items = [ Model::Line.new ]
        end

        line
      end

      before do
        subject.company_id = "9991111222"
        subject.access_token = construct_oauth
      end

      it "queries for sales receipts" do
        xml = fixture("sales_receipts.xml")
        model = Model::SalesReceipt
        stub_http_request(:get, subject.url_for_query, ["200", "OK"], xml)

        receipts = subject.query
        expect(receipts.entries.count).to eq 2
      end

      it "doesnt create sales_receipt without a line item" do
        receipt = Model::SalesReceipt.new

        expect {
          subject.create(receipt)
        }.to raise_error(Quickbooks::InvalidModelException)

        expect(receipt.errors.messages).to have_key(:line_items)
      end

      it "creates a sales receipt" do
        xml = fixture("fetch_sales_receipt_by_id.xml")
        model = Model::SalesReceipt
        stub_http_request(:post, subject.url_for_resource(model::REST_RESOURCE), ["200", "OK"], xml)

        receipt = model.new
        receipt.customer_id = 2

        shipping_reference = Quickbooks::Model::BaseReference.new('FedEx', name: 'FedEx')
        receipt.ship_method_ref = shipping_reference
        receipt.txn_date = Time.now
        receipt.line_items = [line, second_line]

        receipt = subject.create(receipt)
        expect(receipt.line_items.first.description).to eq line.description

        expect(receipt.ship_method_ref.name).to eq('FedEx')
      end

      it "fetches sales receipt by ID" do
        xml = fixture("fetch_sales_receipt_by_id.xml")
        model = Model::SalesReceipt
        stub_http_request(:get, "#{subject.url_for_resource(model::REST_RESOURCE)}/1", ["200", "OK"], xml)

        receipt = subject.fetch_by_id(1)
        expect(receipt.doc_number).to eq "1001"
      end

      it "can void a Sales Receipt" do
        model = Quickbooks::Model::SalesReceipt
        receipt = Quickbooks::Model::SalesReceipt.new
        receipt.doc_number = "1001"
        receipt.sync_token = 2
        receipt.id = 1
        receipt.customer_id = 3
        line_item = Quickbooks::Model::Line.new
        line_item.amount = 50
        line_item.description = "Plush Baby Doll"
        line_item.sales_item! do |detail|
          detail.unit_price = 50
          detail.quantity = 1
          detail.item_id = 1
          detail.tax_code_id = 'NON'
        end
        receipt.line_items << line_item

        xml = fixture("sales_receipt_void_success_response.xml")
        stub_http_request(:post, "#{subject.url_for_resource(model::REST_RESOURCE)}?include=void", ["200", "OK"], xml)

        response = subject.void(receipt)
        expect(response.private_note).to eq('Voided')
      end

      it "can send a sales receipt using bill_email" do
        xml = fixture("sales_receipt_send.xml")
        model = Quickbooks::Model::SalesReceipt
        stub_http_request(:post, "#{subject.url_for_resource(model::REST_RESOURCE)}/1/send", ["200", "OK"], xml)

        sales_receipt = Quickbooks::Model::SalesReceipt.new
        sales_receipt.doc_number = "1001"
        sales_receipt.sync_token = 2
        sales_receipt.id = 1
        sent_sales_receipt = subject.send(sales_receipt)
        expect(sent_sales_receipt.email_status).to eq("EmailSent")
        expect(sent_sales_receipt.delivery_info.delivery_type).to eq("Email")
        expect(sent_sales_receipt.delivery_info.delivery_time).to eq(Time.new(2015, 2, 24, 18, 26, 03, "-08:00"))
      end

      it "can send an sales receipt with new email_address" do
        xml = fixture("sales_receipt_send.xml")
        model = Quickbooks::Model::SalesReceipt
        stub_http_request(:post, "#{subject.url_for_resource(model::REST_RESOURCE)}/1/send?sendTo=test@intuit.com", ["200", "OK"], xml)

        sales_receipt = Quickbooks::Model::SalesReceipt.new
        sales_receipt.doc_number = "1001"
        sales_receipt.sync_token = 2
        sales_receipt.id = 1
        sent_sales_receipt = subject.send(sales_receipt, "test@intuit.com")
        expect(sent_sales_receipt.bill_email.address).to eq("test@intuit.com")
      end

    end
  end
end
