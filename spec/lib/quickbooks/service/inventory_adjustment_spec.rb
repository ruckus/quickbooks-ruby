require 'spec_helper'

module Quickbooks
  module Service
    describe InventoryAdjustment do
      before do
        subject.company_id = "9991111222"
        subject.access_token = construct_oauth
      end

      it "can create an InventoryAdjustment" do
        xml = fixture("fetch_inventory_adjustment.xml")
        model = Quickbooks::Model::InventoryAdjustment
        stub_http_request(:post, subject.url_for_resource(model::REST_RESOURCE), ["200", "OK"], xml)

        inventory_adjustment = model.new
        inventory_adjustment.txn_date = Date.civil(2024, 1, 15)
        inventory_adjustment.adjust_account_id = 80
        inventory_adjustment.build_line_item_for(item_id: 42, qty_diff: -15)


        result = subject.create(inventory_adjustment)
        expect(result.id).to eq("1")
        expect(result.doc_number).to eq("ADJ-1001")
      end

    end
  end
end
