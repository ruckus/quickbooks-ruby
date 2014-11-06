module Quickbooks
  module Service
    class Bill < BaseService

      def delete(bill)
        delete_by_query_string(bill)
      end

      private
      
      def model
        Quickbooks::Model::Bill
      end
    end
  end
end
