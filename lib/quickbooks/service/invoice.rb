module Quickbooks
  module Service
    class Invoice < BaseService
      include ServiceCrud

      def delete(invoice, options = {})
        delete_by_query_string(invoice)
      end

      private

      def default_model_query
        "SELECT * FROM INVOICE"
      end

      def model
        Quickbooks::Model::Invoice
      end
    end
  end
end