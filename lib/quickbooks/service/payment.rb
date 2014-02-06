module Quickbooks
  module Service
    class Payment < BaseService

      def delete(payment)
        delete_by_query_string(payment)
      end

      private

      def default_model_query
        "SELECT * FROM Payment"
      end

      def model
        Quickbooks::Model::Payment
      end
    end
  end
end
