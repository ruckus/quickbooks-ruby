module Quickbooks
  module Service
    class RefundReceipt < BaseService

      def delete(refund_receipt)
        delete_by_query_string(refund_receipt)
      end

      private

      def model
        Quickbooks::Model::RefundReceipt
      end
    end
  end
end
