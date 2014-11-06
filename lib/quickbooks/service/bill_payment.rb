module Quickbooks
  module Service
    class BillPayment < BaseService

      def delete(bill_payment)
        delete_by_query_string(bill_payment)
      end

      private

      def model
        Quickbooks::Model::BillPayment
      end
    end
  end
end
