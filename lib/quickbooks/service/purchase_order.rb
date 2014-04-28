module Quickbooks
  module Service
    class PurchaseOrder < BaseService

      def model
        Quickbooks::Model::PurchaseOrder
      end
    end
  end
end
