require 'spec_helper'

module Quickbooks
  module Service
    describe RefundReceipt do
      let(:line) do
        line = Model::Line.new
        line.amount = 10
        line.description = "Deck Lumber"
        line.sales_item! do |sales_item|
          sales_item.item_id = 34
          sales_item.unit_price = 23
          sales_item.quantity = 15
        end

        line
      end

      before do
        subject.company_id = "9991111222"
        subject.access_token = construct_oauth
      end

      it "queries for refund receipts" do
        xml = fixture("refund_receipts.xml")
        model = Model::RefundReceipt
        stub_http_request(:get, subject.url_for_query, ["200", "OK"], xml)

        receipts = subject.query
        expect(receipts.entries.count).to eq 1
      end

      it "doesnt create refund_receipt without a line item" do
        receipt = Model::RefundReceipt.new

        expect {
          subject.create(receipt)
        }.to raise_error(Quickbooks::InvalidModelException)

        expect(receipt.errors.messages).to have_key(:line_items)
      end

      it "creates a refund receipt" do
        xml = fixture("fetch_refund_receipt_by_id.xml")
        model = Model::RefundReceipt
        stub_http_request(:post, subject.url_for_resource(model::REST_RESOURCE), ["200", "OK"], xml)

        receipt = model.new
        receipt.customer_id = 2
        receipt.deposit_to_account_id = 2
        receipt.txn_date = Time.now
        receipt.line_items = [line]

        receipt = subject.create(receipt)
        expect(receipt.line_items.first.description).to eq line.description
      end

      it "fetches refund receipt by ID" do
        xml = fixture("fetch_refund_receipt_by_id.xml")
        model = Model::RefundReceipt
        stub_http_request(:get, "#{subject.url_for_resource(model::REST_RESOURCE)}/927", ["200", "OK"], xml)

        receipt = subject.fetch_by_id(927)
        expect(receipt.doc_number).to eq "10030"
      end
    end
  end
end
