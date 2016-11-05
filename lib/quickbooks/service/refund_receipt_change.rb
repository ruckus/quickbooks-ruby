module Quickbooks
  module Service
    class RefundReceiptChange < ChangeService

      private

      def entity
        "RefundReceipt"
      end

      def model
        Quickbooks::Model::RefundReceiptChange
      end
    end
  end
end
