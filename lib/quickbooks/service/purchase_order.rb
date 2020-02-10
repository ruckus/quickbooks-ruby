module Quickbooks
  module Service
    class PurchaseOrder < BaseService

      def delete(purchase_order)
        delete_by_query_string(purchase_order)
      end

      def fetch_by_id(id, params = {})
        url = "#{url_for_base}/purchaseorder/#{id}?minorversion=#{Quickbooks::Model::PurchaseOrder::MINORVERSION}"
        fetch_object(model, url, params)
      end

      def url_for_query(query = nil, start_position = 1, max_results = 20, options = {})
        url = super(query, start_position, max_results, options)
        "#{url}&minorversion=#{Quickbooks::Model::PurchaseOrder::MINORVERSION}"
      end

    private

      def model
        Quickbooks::Model::PurchaseOrder
      end
    end
  end
end
