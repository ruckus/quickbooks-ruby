module Quickbooks
  module Service
    class PurchaseOrder < BaseService

      def default_model_query
        "SELECT * FROM PurchaseOrder"
      end

      def model
        Quickbooks::Model::PurchaseOrder
      end
    end
  end
end
