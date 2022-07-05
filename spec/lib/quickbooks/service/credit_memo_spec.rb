require 'spec_helper'

module Quickbooks
  module Service
    describe CreditMemo do
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

      it "can fetch and read a CreditMemo" do
        xml = fixture("fetch_credit_memo.xml")
        model = Quickbooks::Model::CreditMemo
        stub_http_request(:get, "#{subject.url_for_resource(model::REST_RESOURCE)}/52", ["200", "OK"], xml)
        credit_memo = subject.fetch_by_id(52)
        expect(credit_memo.id).to eq("52")
        expect(credit_memo.doc_number).to eq("R3454653464")
      end

      it "creates a credit memo" do
        xml = fixture("fetch_credit_memo.xml")
        model = Model::CreditMemo
        stub_http_request(:post, subject.url_for_resource(model::REST_RESOURCE), ["200", "OK"], xml)

        credit_memo = model.new
        credit_memo.doc_number = "R3454653464"
        credit_memo.customer_id = 2
        credit_memo.payment_method_id = 1
        credit_memo.txn_date = Time.now
        credit_memo.line_items = [line]

        credit_memo = subject.create(credit_memo)
        expect(credit_memo.line_items.first.description).to eq line.description
      end
    end
  end
end
