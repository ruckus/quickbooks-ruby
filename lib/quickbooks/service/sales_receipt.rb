module Quickbooks
  module Service
    class SalesReceipt < BaseService

      def delete(sales_receipt)
        delete_by_query_string(sales_receipt)
      end

      private

      def model
        Quickbooks::Model::SalesReceipt
      end
    end
  end
end
