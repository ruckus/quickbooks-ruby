module Quickbooks
  module Service
    class Bill < BaseService

      def delete(bill, options = {})
        delete_by_query_string(bill)
      end

      def default_model_query
        "SELECT * FROM Bill"
      end

      def model
        Quickbooks::Model::Bill
      end
    end
  end
end
