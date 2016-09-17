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

      before do
        subject.company_id = "9991111222"
        subject.access_token = construct_oauth
      end

      it "queries for sales receipts" do
        xml = fixture("sales_receipts.xml")
        model = Model::SalesReceipt
        stub_request(:get, subject.url_for_query, ["200", "OK"], xml)

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
        stub_request(:post, subject.url_for_resource(model::REST_RESOURCE), ["200", "OK"], xml)

        receipt = model.new
        receipt.customer_id = 2

        shipping_reference = Quickbooks::Model::BaseReference.new('FedEx', name: 'FedEx')
        receipt.ship_method_ref = shipping_reference
        receipt.txn_date = Time.now
        receipt.line_items = [line]

        receipt = subject.create(receipt)
        expect(receipt.line_items.first.description).to eq line.description

        receipt.ship_method_ref.name.should == 'FedEx'
      end

      it "fetches sales receipt by ID" do
        xml = fixture("fetch_sales_receipt_by_id.xml")
        model = Model::SalesReceipt
        stub_request(:get, "#{subject.url_for_resource(model::REST_RESOURCE)}/1", ["200", "OK"], xml)

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
        stub_request(:post, "#{subject.url_for_resource(model::REST_RESOURCE)}?include=void", ["200", "OK"], xml)

        response = subject.void(receipt)
        response.private_note.should == 'Voided'
      end

    end
  end
end
