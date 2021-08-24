# frozen_string_literal: true

module Quickbooks
  module Service
    class InventoryAdjustment < BaseService
      def delete(inventory_adjustment)
        delete_by_query_string(inventory_adjustment)
      end

      def fetch_by_id(id, params = {})
        url = "#{url_for_base}/inventoryadjustment/#{id}"
        fetch_object(model, url, params)
      end

      private

      def model
        Quickbooks::Model::InventoryAdjustment
      end
    end
  end
end
