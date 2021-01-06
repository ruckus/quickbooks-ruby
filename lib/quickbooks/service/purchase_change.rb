module Quickbooks
  module Service
    class PurchaseChange < ChangeService

      private

      def entity
        "Purchase"
      end

      def model
        Quickbooks::Model::PurchaseChange
      end
    end
  end
end
