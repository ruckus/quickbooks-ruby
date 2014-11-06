module Quickbooks
  module Service
    class Invoice < BaseService

      def delete(invoice)
        delete_by_query_string(invoice)
      end

      private
      
      def model
        Quickbooks::Model::Invoice
      end
    end
  end
end
