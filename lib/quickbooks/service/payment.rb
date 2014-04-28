module Quickbooks
  module Service
    class Payment < BaseService

      def delete(payment)
        delete_by_query_string(payment)
      end

      private

      def model
        Quickbooks::Model::Payment
      end
    end
  end
end
