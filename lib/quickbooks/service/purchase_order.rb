module Quickbooks
  module Service
    class PurchaseOrder < BaseService

      private
      
      def model
        Quickbooks::Model::PurchaseOrder
      end
    end
  end
end
